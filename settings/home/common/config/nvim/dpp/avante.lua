-- lua_add {{{
require("avante").setup({
    provider = "copilot",
    auto_suggestions_provider = "copilot",
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
