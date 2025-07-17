--- ddt.vim terminal provider for Claude Code.
-- @module claudecode.terminal.ddt

--- @type TerminalProvider
local M = {}

local logger = require("claudecode.logger")
local utils = require("claudecode.utils")

--- @type string?
local terminal_name = nil
local config = {
    name = "claudecode",
    size = 15,
    direction = "horizontal", -- horizontal, vertical, float
    split = "botright",
    focus_on_open = true,
    close_on_exit = true,
}

-- Function existence cache for performance optimization
local function_cache = {}

--- Check if a function exists with caching
--- @param func_name string
--- @return boolean
local function is_function_available(func_name)
    if function_cache[func_name] ~= nil then
        return function_cache[func_name]
    end

    local exists = vim.fn.exists("*" .. func_name) == 1
    function_cache[func_name] = exists
    return exists
end

--- Validate that all required ddt.vim API functions are available
--- @return boolean, string?
local function validate_ddt_api()
    local required_functions = {
        "ddt#start",
        "ddt#ui#do_action",
        "ddt#custom#load_config",
        "ddt#ui#get_current",
    }

    for _, func in ipairs(required_functions) do
        if not is_function_available(func) then
            return false, "Missing required ddt.vim function: " .. func
        end
    end

    return true
end

--- Validate configuration parameters
--- @param cfg table
--- @return boolean, string?
local function validate_config(cfg)
    if not cfg or type(cfg) ~= "table" then
        return false, "Configuration must be a table"
    end

    -- Validate direction
    if cfg.direction then
        local valid_directions = { "horizontal", "vertical", "float" }
        if not vim.tbl_contains(valid_directions, cfg.direction) then
            return false,
                "Invalid direction: " .. cfg.direction .. ". Must be one of: " .. table.concat(valid_directions, ", ")
        end
    end

    -- Validate split
    if cfg.split and type(cfg.split) ~= "string" then
        return false, "split must be a string"
    end

    -- Validate size
    if cfg.size and (type(cfg.size) ~= "number" or cfg.size <= 0) then
        return false, "size must be a positive number"
    end

    -- Validate boolean parameters
    local boolean_params = { "focus_on_open", "close_on_exit" }
    for _, param in ipairs(boolean_params) do
        if cfg[param] ~= nil and type(cfg[param]) ~= "boolean" then
            return false, param .. " must be a boolean"
        end
    end

    -- Validate name
    if cfg.name and type(cfg.name) ~= "string" then
        return false, "name must be a string"
    end

    return true
end

--- Validate and sanitize input text/commands
--- @param input string
--- @param input_type string
--- @return boolean, string?
local function validate_and_sanitize_input(input, input_type)
    if type(input) ~= "string" then
        return false, input_type .. " must be a string"
    end

    if input == "" then
        return false, input_type .. " cannot be empty"
    end

    -- Remove null bytes and control characters for safety
    local sanitized = input:gsub("[\0\1-\8\11-\12\14-\31\127]", "")

    -- Check for potentially dangerous command patterns
    local dangerous_patterns = {
        "rm%s+%-rf",
        "sudo%s+rm",
        ">/dev/null",
        "2>&1",
        "&&",
        "||",
        ";",
        "|",
    }

    for _, pattern in ipairs(dangerous_patterns) do
        if sanitized:match(pattern) then
            logger.warn("terminal", "Potentially dangerous " .. input_type .. " pattern detected: " .. pattern)
        end
    end

    return true, sanitized
end

--- Get actual ddt.vim terminal state
--- @return boolean
local function get_actual_ddt_state()
    if not is_function_available("ddt#ui#get_current") then
        return false
    end

    local success, result = pcall(vim.fn["ddt#ui#get_current"])
    if not success then
        logger.error("terminal", "Failed to get ddt.vim state: " .. tostring(result))
        return false
    end

    return result ~= nil and result ~= ""
end

--- Enhanced cleanup with ddt.vim cleanup actions
local function cleanup_state()
    -- Try to call ddt.vim cleanup action
    if is_function_available("ddt#ui#do_action") then
        local success, _ = pcall(vim.fn["ddt#ui#do_action"], "cleanup")
        if not success then
            logger.debug("terminal", "ddt.vim cleanup action failed, continuing with local cleanup")
        end
    end

    terminal_name = nil
    logger.debug("terminal", "Terminal state cleaned up")
end

--- @return boolean
local function is_valid()
    if not terminal_name then
        return false
    end

    -- Check if ddt.vim is available
    local api_valid, api_error = validate_ddt_api()
    if not api_valid then
        logger.error("terminal", "ddt.vim API validation failed: " .. (api_error or "unknown error"))
        return false
    end

    return true
end

--- Create ddt.vim configuration for terminal
--- @param cmd_string string?
--- @param env_table table?
--- @return table
local function create_ddt_config(cmd_string, env_table)
    local ddt_config = {
        name = config.name,
        ui = "terminal",
        uiParams = {
            terminal = {
                split = config.direction,
                size = config.size,
                direction = config.split,
                focus = config.focus_on_open,
                closeOnExit = config.close_on_exit,
            },
        },
    }

    -- Add command and environment if provided
    if cmd_string then
        ddt_config.command = cmd_string
    end

    if env_table and next(env_table) then
        ddt_config.env = env_table
    end

    return ddt_config
end

local function open_terminal(cmd_string, env_table, focus)
    focus = utils.normalize_focus(focus)

    -- Validate ddt.vim API availability
    local api_valid, api_error = validate_ddt_api()
    if not api_valid then
        logger.error("terminal", "ddt.vim API validation failed: " .. (api_error or "unknown error"))
        return false
    end

    -- Validate command string if provided
    if cmd_string then
        local cmd_valid, sanitized_cmd = validate_and_sanitize_input(cmd_string, "command")
        if not cmd_valid then
            logger.error("terminal", "Invalid command: " .. (sanitized_cmd or "unknown error"))
            return false
        end
        cmd_string = sanitized_cmd
    end

    -- If terminal is already open, just focus if requested
    if get_actual_ddt_state() and focus then
        local success, result = pcall(vim.fn["ddt#ui#do_action"], "focus")
        if success and result then
            vim.cmd("startinsert")
        end
        return true
    end

    -- Create ddt.vim configuration
    local ddt_config = create_ddt_config(cmd_string, env_table)

    -- Start ddt.vim terminal with safe API call
    local success, result = pcall(vim.fn["ddt#start"], ddt_config)

    if not success then
        logger.error("terminal", "Failed to start ddt.vim terminal: " .. tostring(result))
        return false
    end

    if not result then
        logger.error("terminal", "ddt.vim terminal start returned false")
        return false
    end

    terminal_name = config.name

    if focus then
        vim.cmd("startinsert")
    end

    logger.debug("terminal", "ddt.vim terminal opened successfully")
    return true
end

--- Initialize the terminal provider
--- @param user_config table?
function M.init(user_config)
    if user_config then
        local config_valid, config_error = validate_config(user_config)
        if not config_valid then
            logger.error("terminal", "Invalid configuration: " .. (config_error or "unknown error"))
            return
        end
    end

    config = vim.tbl_deep_extend("force", config, user_config or {})
    logger.debug("terminal", "ddt.vim terminal provider initialized")
end

--- Open terminal with optional command
--- @param cmd_string string?
--- @param env_table table?
--- @param focus boolean?
--- @return boolean
function M.open(cmd_string, env_table, focus)
    return open_terminal(cmd_string, env_table, focus)
end

--- Close the terminal
--- @return boolean
function M.close()
    if not is_valid() then
        return false
    end

    local success, result = pcall(vim.fn["ddt#ui#do_action"], "quit")

    if not success then
        logger.error("terminal", "Failed to close ddt.vim terminal: " .. tostring(result))
        return false
    end

    if result then
        cleanup_state()
        logger.debug("terminal", "ddt.vim terminal closed")
        return true
    else
        logger.error("terminal", "ddt.vim terminal close returned false")
        return false
    end
end

--- Toggle terminal visibility
--- @param cmd_string string?
--- @param env_table table?
--- @param focus boolean?
--- @return boolean
function M.toggle(cmd_string, env_table, focus)
    -- Validate ddt.vim API availability
    local api_valid, api_error = validate_ddt_api()
    if not api_valid then
        logger.error("terminal", "ddt.vim API validation failed: " .. (api_error or "unknown error"))
        return false
    end

    -- Use ddt.vim's toggle action with safe API call
    local success, result = pcall(vim.fn["ddt#ui#do_action"], "toggle")

    if not success then
        logger.error("terminal", "Failed to toggle ddt.vim terminal: " .. tostring(result))
        -- If toggle fails, try to open the terminal
        return M.open(cmd_string, env_table, focus)
    end

    if result then
        local actual_state = get_actual_ddt_state()
        if actual_state then
            terminal_name = config.name
            if utils.normalize_focus(focus) then
                vim.cmd("startinsert")
            end
        else
            cleanup_state()
        end
        logger.debug("terminal", "ddt.vim terminal toggled")
        return true
    else
        -- If toggle fails, try to open the terminal
        return M.open(cmd_string, env_table, focus)
    end
end

--- Focus the terminal window
--- @return boolean
function M.focus()
    if not is_valid() then
        logger.warn("terminal", "No valid ddt.vim terminal to focus")
        return false
    end

    local success, result = pcall(vim.fn["ddt#ui#do_action"], "focus")

    if not success then
        logger.error("terminal", "Failed to focus ddt.vim terminal: " .. tostring(result))
        return false
    end

    if result then
        vim.cmd("startinsert")
        logger.debug("terminal", "ddt.vim terminal focused")
        return true
    else
        logger.error("terminal", "ddt.vim terminal focus returned false")
        return false
    end
end

--- Send text to terminal
--- @param text string
--- @return boolean
function M.send_text(text)
    if not is_valid() then
        logger.warn("terminal", "No active ddt.vim terminal to send text to")
        return false
    end

    -- Validate and sanitize input text
    local text_valid, sanitized_text = validate_and_sanitize_input(text, "text")
    if not text_valid then
        logger.error("terminal", "Invalid text input: " .. (sanitized_text or "unknown error"))
        return false
    end

    local success, result = pcall(vim.fn["ddt#ui#do_action"], "sendText", { text = sanitized_text })

    if not success then
        logger.error("terminal", "Failed to send text to ddt.vim terminal: " .. tostring(result))
        return false
    end

    if result then
        logger.debug("terminal", "Sent text to ddt.vim terminal: " .. sanitized_text)
        return true
    else
        logger.error("terminal", "ddt.vim terminal send text returned false")
        return false
    end
end

--- Send command to terminal
--- @param command string
--- @return boolean
function M.send_command(command)
    if not is_valid() then
        logger.warn("terminal", "No active ddt.vim terminal to send command to")
        return false
    end

    -- Validate and sanitize input command
    local cmd_valid, sanitized_cmd = validate_and_sanitize_input(command, "command")
    if not cmd_valid then
        logger.error("terminal", "Invalid command input: " .. (sanitized_cmd or "unknown error"))
        return false
    end

    local success, result = pcall(vim.fn["ddt#ui#do_action"], "sendCommand", { command = sanitized_cmd })

    if not success then
        logger.error("terminal", "Failed to send command to ddt.vim terminal: " .. tostring(result))
        return false
    end

    if result then
        logger.debug("terminal", "Sent command to ddt.vim terminal: " .. sanitized_cmd)
        return true
    else
        logger.error("terminal", "ddt.vim terminal send command returned false")
        return false
    end
end

--- Check if terminal is open
--- @return boolean
function M.is_open()
    return get_actual_ddt_state() and is_valid()
end

--- Get terminal name
--- @return string?
function M.get_terminal_name()
    return terminal_name
end

--- Get configuration
--- @return table
function M.get_config()
    return config
end

return M
