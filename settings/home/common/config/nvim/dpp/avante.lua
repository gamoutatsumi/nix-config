-- lua_source {{{
require("avante").setup({
    provider = require("avante-status").get_chat_provider({ "copilot" }),
    auto_suggestions_provider = "copilot",
    copilot = {
        model = "claude-3.7-sonnet",
    },
    behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        minimize_diff = true,
        enable_token_counting = true,
        enable_cursor_planning_mode = false,
        support_paste_from_clipboard = false,
    },
    windows = {
        position = "right",
        wrap = true,
        width = 30,
    },
})
-- }}}
