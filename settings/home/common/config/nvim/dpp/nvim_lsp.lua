-- lua_add {{{
local lspconfig = require("lspconfig")

local function setInlayHintHL()
    local has_hl, hl = pcall(vim.api.nvim_get_hl, 0, { name = "LspInlayHint" })
    if has_hl and (hl["fg"] or hl["bg"]) then
        return
    end

    hl = vim.api.nvim_get_hl(0, { name = "Comment" })
    local foreground = string.format("#%06x", hl["fg"] or 0)
    if #foreground < 3 then
        foreground = ""
    end

    hl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
    local background = string.format("#%06x", hl["bg"] or 0)
    if #background < 3 then
        background = ""
    end

    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = foreground, bg = background })
end

require("ddc_source_lsp_setup").setup({ override_capabilities = true, respect_trigger = true })

local on_attach = function(client, bufnr)
    local function format()
        local formatOpts = {
            filter = function(formatterClient)
                if formatterClient.name == "lua_ls" then
                    return false
                elseif formatterClient.name == "ts_ls" then
                    return false
                elseif formatterClient.name == "vtsls" then
                    return false
                end
                return true
            end,
        }
        vim.lsp.buf.format(formatOpts)
    end
    vim.diagnostic.config({
        virtual_lines = true,
        virtual_text = false,
        float = false,
        underline = true,
    })
    vim.b.copilot_workspace_folder = vim.lsp.buf.list_workspace_folders()[1]
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = false })
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = false })
    end, opts)
    vim.keymap.set("n", "<Leader>f", format, opts)
    vim.keymap.set("n", "<Leader>ld", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, opts)
    require("lsp_signature").on_attach({
        bind = true,
        handler_opts = {
            border = "rounded",
        },
    }, bufnr)
    if client:supports_method("textDocument/inlayHint") or client.name == "sourcekit" then
        setInlayHintHL()
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end,
        })
        vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end,
        })
        local timer = vim.uv.new_timer()
        timer:start(
            100,
            0,
            vim.schedule_wrap(function()
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end)
        )
    end
end

vim.lsp.config("*", { on_attach = on_attach })

lspconfig.astro.setup({
    on_attach = on_attach,
    autostart = true,
})

if vim.fn.executable("typescript-language-server") == 1 then
    vim.lsp.enable("ts_ls")
end

if vim.fn.executable("vtsls") == 1 then
    vim.lsp.enable("vtsls")
end

if vim.fn.executable("typescript-language-server") == 0 and vim.fn.executable("vtsls") == 0 then
    vim.lsp.enable("denols")
end

vim.lsp.enable({
    "hls",
    "nil_ls",
    "sourcekit",
    "gopls",
    "jsonls",
    "terraformls",
    "pyright",
    "rust_analyzer",
    "fennel_language_server",
    "biome",
    "unocss",
    "lua_ls",
})
-- }}}
