return {
    root_dir = function(bufnr, callback)
        local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
        local disable_patterns = { "env", "conf", "local", "private" }
        local is_disabled = vim.iter(disable_patterns):any(function(pattern)
            return string.match(fname, pattern)
        end)
        if is_disabled then
            return
        end

        local root_dir = vim.fs.root(bufnr, { ".git" })
        if root_dir then
            return callback(root_dir)
        end
    end,
    on_init = function()
        local hlc = vim.api.nvim_get_hl(0, { name = "Comment" })
        vim.api.nvim_set_hl(0, "ComplHint", vim.tbl_extend("force", hlc, { underline = true }))
        local hlm = vim.api.nvim_get_hl(0, { name = "MoreMsg" })
        vim.api.nvim_set_hl(0, "ComplHintMore", vim.tbl_extend("force", hlm, { underline = true }))

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf

                -- インライン補完を有効に
                vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

                vim.keymap.set("i", "<C-e>", function()
                    vim.lsp.inline_completion.get()
                    if vim.fn.pumvisible() == 1 then
                        return "<C-e>"
                    end
                end, {
                    silent = true,
                    expr = true,
                    buffer = bufnr,
                    desc = "Get Copilot Inline Completion",
                })
            end,
        })
    end,
}
