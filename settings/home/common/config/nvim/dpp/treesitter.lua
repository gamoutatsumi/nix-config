-- lua_add {{{
local data_dir = vim.fn.stdpath("data")
if type(data_dir) ~= "string" then
    data_dir = data_dir[1]
end
vim.opt.runtimepath:prepend("@treesitter_parsers@")
require("nvim-treesitter.configs").setup({
    -- keep-sorted start block=yes
    auto_install = false,
    autotag = {
        enable = true,
    },
    ensure_installed = {},
    highlight = {
        enable = true,
        disable = { "vim" },
    },
    ignore_install = {},
    incremental_selection = { enable = true },
    indent = { enable = true },
    modules = {},
    selection_modes = {
        ["@parameter.outer"] = "v",
        ["@function.outer"] = "V",
        ["@class.outer"] = "V",
    },
    sync_install = false,
    textobjects = {
        enable = true,
        lookahead = true,
        keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
        },
        swap = {
            enable = true,
            swap_next = {
                ["g>"] = "@parameter.inner",
            },
            swap_previous = {
                ["g<"] = "@parameter.inner",
            },
        },
    },
    -- keep-sorted end
})
-- }}}
