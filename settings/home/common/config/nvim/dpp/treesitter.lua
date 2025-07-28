-- lua_add {{{

local ts = require("nvim-treesitter")
vim.opt.runtimepath:prepend("@treesitter_parsers@")
vim.opt.runtimepath:prepend("@runtime@")
local filetypes = {}
for _, lang in ipairs(ts.get_available(2)) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(filetypes, ft)
    end
end

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

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
        },
        include_surrounding_whitespace = false,
    },
})

local swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "g>", function()
    swap.swap_next("@parameter.inner")
end)
vim.keymap.set("n", "g<", function()
    swap.swap_previous("@parameter.inner")
end)

local select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
    select.select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
    select.select_textobject("@class.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
    select.select_textobject("@local.scope", "locals")
end)
-- }}}
