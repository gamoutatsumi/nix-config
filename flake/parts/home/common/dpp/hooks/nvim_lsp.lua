-- lua_add {{{
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

local ensure_enabled = {
    -- keep-sorted start
    "alloy_ls",
    "astro",
    "bashls",
    "biome",
    "buf_ls",
    "cue",
    "docker_language_server",
    "efm",
    "eslint",
    "fennel_language_server",
    "golangci_lint_ls",
    "gopls",
    "hls",
    "jinja_lsp",
    "jsonls",
    "lua_ls",
    "nil_ls",
    "pyright",
    "rust_analyzer",
    "sourcekit",
    "statix",
    "stylua",
    "terraformls",
    "texlab",
    "tombi",
    "typos_lsp",
    "unocss",
    "yamlls",
    -- keep-sorted end
}
vim.lsp.enable(ensure_enabled)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
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
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.INFO] = "",
                    [vim.diagnostic.severity.HINT] = "",
                },
                numhl = {
                    [vim.diagnostic.severity.WARN] = "WarningMsg",
                    [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                    [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
                    [vim.diagnostic.severity.HINT] = "DiagnosticHint",
                },
            },
        })
        vim.b.copilot_workspace_folder = vim.lsp.buf.list_workspace_folders()[1]
        vim.keymap.set(
            "n",
            "<Leader>e",
            vim.diagnostic.open_float,
            { noremap = true, silent = true, buffer = bufnr, desc = "vim.diagnostic.open_float" }
        )
        vim.keymap.set(
            "n",
            "K",
            vim.lsp.buf.hover,
            { noremap = true, silent = true, bufnr = bufnr, desc = "vim.lsp.buf.hover" }
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
            if not timer then
                return
            end
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
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LspStartNodeOrDeno", { clear = true }),
    callback = function(ctx)
        if
            not vim.tbl_contains(
                { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
                ctx.match
            )
        then
            return
        end

        -- node
        if vim.fn.finddir("node_modules", ".;") ~= "" then
            vim.lsp.enable("vtsls")
            return
        end

        -- deno
        vim.lsp.enable("denols")
    end,
})
-- }}}
