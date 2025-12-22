-- lua_add {{{
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        require("lsp_signature").on_attach({
            bind = true,
            handler_opts = {
                border = "rounded",
            },
        }, bufnr)
    end,
})
-- }}}
