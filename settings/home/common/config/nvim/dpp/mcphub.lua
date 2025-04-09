-- lua_add {{{
require("mcphub").setup({
    port = 3000,
    config = vim.fn.expand("~/.config/mcp/mcpservers.json"),
    cmd = "@mcp_hub@",

    on_ready = function(hub) end,
    on_error = function(err) end,
    log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
    },
    extensions = {
        avante = {
            make_slash_command = true,
        },
    },
    use_bundled_binary = false,
})
-- }}}
