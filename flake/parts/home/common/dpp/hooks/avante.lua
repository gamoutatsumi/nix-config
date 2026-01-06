-- lua_add {{{
require("avante").setup({
    provider = "opencode",
    acp_providers = {
        opencode = { command = "opencode", args = "acp" },
    },
    mode = "agentic",
    behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        auto_add_current_file = true,
        auto_approve_tool_permissions = true,
        confirmation_ui_style = "inline_buttons",
        acp_follow_agent_locations = true,
    },
})
--}}}
