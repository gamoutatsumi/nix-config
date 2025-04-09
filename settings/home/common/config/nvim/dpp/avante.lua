-- lua_source {{{
require("avante").setup({
    auto_suggestions_provider = "ollama",
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
    custom_tools = function()
        return {
            require("mcphub.extensions.avante").mcp_tool(),
        }
    end,
    disabled_tools = {
        "list_files",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
    },
    file_selector = {
        provider = "native",
    },
    copilot = {
        model = "gpt-4o",
    },
    ollama = {
        model = "phi4",
    },
    provider = "ollama",
    system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
    end,
    windows = {
        position = "right",
        wrap = true,
        width = 30,
    },
})
-- }}}
