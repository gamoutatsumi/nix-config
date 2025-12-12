-- lua_add {{{
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
