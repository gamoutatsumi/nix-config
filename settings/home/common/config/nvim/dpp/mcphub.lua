-- lua_add {{{
require("mcphub").setup({
    -- Required options
    port = 3000, -- Port for MCP Hub server
    config = vim.fn.expand("~/.config/mcp/mcpservers.json"), -- Absolute path to config file

    -- Optional options
    on_ready = function(hub)
        -- Called when hub is ready
    end,
    on_error = function(err)
        -- Called on errors
    end,
    log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
    },
})
-- }}}
