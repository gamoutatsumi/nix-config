-- lua_add {{{
require("hover").setup({
    init = function()
        -- Require providers
        require("hover.providers.gh")
        require("hover.providers.lsp")
        -- require('hover.providers.gh_user')
        -- require('hover.providers.jira')
        -- require('hover.providers.man')
        -- require('hover.providers.dictionary')
    end,
    preview_opts = {
        border = "double",
    },
    -- Whether the contents of a currently open hover window should be moved
    -- to a :h preview-window when pressing the hover keymap.
    preview_window = true,
    title = true,
})

-- Setup keymaps
vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
-- }}}
