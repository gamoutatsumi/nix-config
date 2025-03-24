-- lua_source {{{
require("avante").setup({
    provider = "ollama",
    auto_suggestions_provider = "copilot",
    copilot = {
        model = "gpt-4o",
    },
    ollama = {
        model = "codestral:22b-v0.1-q4_K_S",
    },
    file_selector = {
        provider = "native",
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
