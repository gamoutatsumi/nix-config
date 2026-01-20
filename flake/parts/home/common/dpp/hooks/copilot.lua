-- lua_add {{{
require("copilot").setup({
    panel = {
        enabled = false,
    },
    suggestion = {
        enabled = false,
    },
    filetypes = {
        yaml = true,
        markdown = false,
        help = false,
        gitcommit = true,
        gitrebase = true,
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
    server = { type = "binary", custom_server_filepath = "@copilot_ls@" },
    server_opts_overrides = {},
})
-- }}}
