-- lua_source {{{
require("copilot").setup({
    panel = {
        enabled = false,
    },
    suggestion = {
        enabled = false,
    },
    filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
        ["*"] = true,
    },
    copilot_node_command = "node", -- Node.js version must be > 18.x
    workspace_folders = {},
    -- copilot_model = "gpt-4o-copilot", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
    root_dir = function()
        return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
    end,
    server_opts_overrides = {
        trace = "verbose",
        cmd = {
            "@copilot_ls@",
            "--stdio",
        },
        settings = {
            advanced = {
                listCount = 10,
                inlineSuggestCount = 3,
            },
        },
    },
})
-- }}}
