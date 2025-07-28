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

---@type vim.lsp.client.on_attach_cb
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
    vim.keymap.set(
        "n",
        "<Leader>e",
        vim.diagnostic.open_float,
        { noremap = true, silent = true, buffer = bufnr, desc = "vim.diagnostic.open_float" }
    )
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = false })
    end, { noremap = true, silent = true, buffer = bufnr, desc = "vim.diagnostic.prev" })
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = false })
    end, { noremap = true, silent = true, buffer = bufnr, desc = "vim.diagnostic.next" })
    vim.keymap.set(
        "n",
        "<Leader>f",
        format,
        { noremap = true, silent = true, buffer = bufnr, desc = "vim.lsp.buf.format" }
    )
    vim.keymap.set("n", "<Leader>ld", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, { noremap = true, silent = true, buffer = bufnr, desc = "vim.diagnostic.toggle" })
    require("lsp_signature").on_attach({
        bind = true,
        handler_opts = {
            border = "rounded",
        },
    }, bufnr)
    if client:supports_method("textDocument/inlayHint") or client.name == "sourcekit" then
        setInlayHintHL()
        vim.api.nvim_create_autocmd("InsertEnter", {
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end,
        })
        vim.api.nvim_create_autocmd("InsertLeave", {
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
    if client:supports_method("textDocument/codeLens") then
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh()
            end,
        })
    end
end

vim.lsp.config("*", { on_attach = on_attach })

lspconfig.astro.setup({
    on_attach = on_attach,
    autostart = true,
})

local ensure_enabled = {
    -- keep-sorted start
    "biome",
    "buf_ls",
    "cue",
    "denols",
    "efm",
    "fennel_language_server",
    "golangci_lint_ls",
    "gopls",
    "hls",
    "jsonls",
    "lua_ls",
    "nil_ls",
    "pyright",
    "rust_analyzer",
    "sourcekit",
    "terraformls",
    "tombi",
    "typos_lsp",
    "unocss",
    "vtsls",
    -- keep-sorted end
}
vim.lsp.enable(ensure_enabled)
-- }}}
