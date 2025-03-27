-- lua_add {{{
local data_dir = vim.fn.stdpath("data")
if type(data_dir) ~= "string" then
    data_dir = data_dir[1]
end
vim.opt.runtimepath:prepend("@treesitter_parsers@")
require("nvim-treesitter.configs").setup({
    -- Modules and its options go here
    ensure_installed = {},
    highlight = {
        enable = true,
        disable = { "vim" },
    },
    auto_install = false,
    incremental_selection = { enable = true },
    textobjects = {
        enable = true,
        lookahead = true,
        keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
        },
    },
    indent = { enable = true },
    refactor = {
        highlight_definitions = { enable = false },
        highlight_current_scope = { enable = false },
        smart_rename = {
            enable = false,
        },
    },
    autotag = {
        enable = true,
    },
    sync_install = false,
    ignore_install = {},
    modules = {},
})
-- }}}
