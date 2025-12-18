local filetypes = {}
for _, lang in ipairs(require("nvim-treesitter").get_available(2)) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(filetypes, ft)
    end
    table.insert(filetypes, "typescriptreact")
    table.insert(filetypes, "javascriptreact")
end

vim.treesitter.language.register("tsx", { "typescriptreact", "javascriptreact" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(args)
        local max_filesize = 512 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
            vim.notify(
                string.format("File too large (%d bytes), disabling treesitter", stats.size),
                vim.log.levels.WARN
            )
            return
        end
        vim.treesitter.start(args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
})
