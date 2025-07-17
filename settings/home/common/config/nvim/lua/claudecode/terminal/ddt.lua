--- ddt.vim terminal provider for Claude Code.
-- @module claudecode.terminal.ddt

--- @type TerminalProvider
local M = {}

local logger = require("claudecode.logger")
local utils = require("claudecode.utils")

--- @type string?
local terminal_name = nil
local is_open = false
local config = {
    name = "claudecode",
    size = 15,
    direction = "horizontal", -- horizontal, vertical, float
    split = "botright",
    focus_on_open = true,
    close_on_exit = true,
}

local function cleanup_state()
    terminal_name = nil
    is_open = false
end

--- @return boolean
local function is_valid()
    if not terminal_name then
        return false
    end

    -- Check if ddt.vim is available
    if not vim.fn.exists("*ddt#start") then
        logger.error("terminal", "ddt.vim is not available")
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

local function open_terminal(cmd_string, env_table, effective_config, focus)
    focus = utils.normalize_focus(focus)

    -- Check if ddt.vim is available
    if not vim.fn.exists("*ddt#start") then
        logger.error("terminal", "ddt.vim is not available")
        return false
    end

    -- If terminal is already open, just focus if requested
    if is_open and focus then
        local result = vim.fn["ddt#ui#do_action"]("focus")
        if result then
            vim.cmd("startinsert")
        end
        return true
    end

    -- Create ddt.vim configuration
    local ddt_config = create_ddt_config(cmd_string, env_table)

    -- Start ddt.vim terminal
    local result = vim.fn["ddt#start"](ddt_config)

    if not result then
        logger.error("terminal", "Failed to start ddt.vim terminal")
        return false
    end

    terminal_name = config.name
    is_open = true

    if focus then
        vim.cmd("startinsert")
    end

    logger.debug("terminal", "ddt.vim terminal opened successfully")
    return true
end

--- Initialize the terminal provider
--- @param user_config table?
function M.init(user_config)
    config = vim.tbl_deep_extend("force", config, user_config or {})
    logger.debug("terminal", "ddt.vim terminal provider initialized")
end

--- Open terminal with optional command
--- @param cmd_string string?
--- @param env_table table?
--- @param effective_config table?
--- @param focus boolean?
--- @return boolean
function M.open(cmd_string, env_table, effective_config, focus)
    return open_terminal(cmd_string, env_table, effective_config, focus)
end

--- Close the terminal
--- @return boolean
function M.close()
    if not is_valid() then
        return false
    end

    local result = vim.fn["ddt#ui#do_action"]("quit")

    if result then
        cleanup_state()
        logger.debug("terminal", "ddt.vim terminal closed")
        return true
    else
        logger.error("terminal", "Failed to close ddt.vim terminal")
        return false
    end
end

--- Toggle terminal visibility
--- @param cmd_string string?
--- @param env_table table?
--- @param effective_config table?
--- @param focus boolean?
--- @return boolean
function M.toggle(cmd_string, env_table, effective_config, focus)
    if not vim.fn.exists("*ddt#ui#do_action") then
        logger.error("terminal", "ddt.vim UI actions not available")
        return false
    end

    -- Use ddt.vim's toggle action
    local result = vim.fn["ddt#ui#do_action"]("toggle")

    if result then
        is_open = not is_open
        if is_open then
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
        return M.open(cmd_string, env_table, effective_config, focus)
    end
end

--- Focus the terminal window
--- @return boolean
function M.focus()
    if not is_valid() then
        logger.warn("terminal", "No valid ddt.vim terminal to focus")
        return false
    end

    local result = vim.fn["ddt#ui#do_action"]("focus")

    if result then
        vim.cmd("startinsert")
        logger.debug("terminal", "ddt.vim terminal focused")
        return true
    else
        logger.error("terminal", "Failed to focus ddt.vim terminal")
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

    local result = vim.fn["ddt#ui#do_action"]("sendText", { text = text })

    if result then
        logger.debug("terminal", "Sent text to ddt.vim terminal: " .. text)
        return true
    else
        logger.error("terminal", "Failed to send text to ddt.vim terminal")
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

    local result = vim.fn["ddt#ui#do_action"]("sendCommand", { command = command })

    if result then
        logger.debug("terminal", "Sent command to ddt.vim terminal: " .. command)
        return true
    else
        logger.error("terminal", "Failed to send command to ddt.vim terminal")
        return false
    end
end

--- Check if terminal is open
--- @return boolean
function M.is_open()
    return is_open and is_valid()
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
