-- lua_add {{{
local data_dir = vim.fn.stdpath("data")
if type(data_dir) ~= "string" then
    data_dir = data_dir[1]
end
local parser_install_dir = vim.fs.joinpath(data_dir, "treesitter")
vim.opt.runtimepath:prepend(parser_install_dir)
require("nvim-treesitter.configs").setup({
    -- Modules and its options go here
    ensure_installed = {
        -- keep-sorted start
        "astro",
        "bash",
        "comment",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "graphql",
        "haskell",
        "hcl",
        "javascript",
        "jinja",
        "jinja_inline",
        "jq",
        "json",
        "lua",
        "markdown_inline",
        "mermaid",
        "nix",
        "proto",
        "python",
        "regex",
        "rust",
        "sql",
        "ssh_config",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        -- keep-sorted end
    },
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
    parser_install_dir = parser_install_dir,
    sync_install = false,
    ignore_install = {},
    modules = {},
})
-- }}}
