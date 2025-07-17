--- ddt.vim terminal provider for Claude Code.
-- @module claudecode.terminal.ddt

--- @type TerminalProvider
local M = {}

local logger = require("claudecode.logger")
local utils = require("claudecode.utils")

--- @type integer?
local bufnr = nil
--- @type integer?
local winid = nil
--- @type integer?
local jobid = nil
local is_open = false
local config = {
    size = 15,
    direction = "horizontal", -- horizontal, vertical, float
    split = "botright",
    focus_on_open = true,
    close_on_exit = true,
}

local function cleanup_state()
    bufnr = nil
    winid = nil
    jobid = nil
    is_open = false
end

--- @return boolean
local function is_valid()
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        cleanup_state()
        return false
    end

    if not winid or not vim.api.nvim_win_is_valid(winid) then
        local windows = vim.api.nvim_list_wins()
        for _, win in ipairs(windows) do
            if vim.api.nvim_win_get_buf(win) == bufnr then
                winid = win
                logger.debug("terminal", "Recovered terminal window ID: " .. win)
                return true
            end
        end
        return false
    end
    return true
end

local function setup_terminal_buffer()
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        return bufnr
    end

    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(bufnr, "filetype", "terminal")
    vim.api.nvim_buf_set_option(bufnr, "buflisted", false)

    -- Auto-cleanup on buffer deletion
    vim.api.nvim_create_autocmd("BufDelete", {
        buffer = bufnr,
        callback = function()
            cleanup_state()
        end,
    })

    return bufnr
end

local function open_terminal_window()
    if winid and vim.api.nvim_win_is_valid(winid) then
        return winid
    end

    local buf = setup_terminal_buffer()

    -- Use ddt.vim to create terminal UI
    vim.cmd("botright split")
    winid = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(winid, buf)
    vim.api.nvim_win_set_height(winid, config.size)

    return winid
end

local function open_terminal(cmd_string, env_table, effective_config, focus)
    focus = utils.normalize_focus(focus)

    if is_valid() then
        --- @cast winid -?
        if focus then
            vim.api.nvim_set_current_win(winid)
            vim.cmd("startinsert")
        end
        return true
    end

    -- Setup terminal window
    local win = open_terminal_window()
    if not win then
        logger.error("terminal", "Failed to create terminal window")
        return false
    end

    -- Start terminal job
    vim.api.nvim_set_current_win(win)

    local cmd = cmd_string or vim.o.shell
    local env = env_table or {}

    jobid = vim.fn.termopen(cmd, {
        env = env,
        on_exit = function(job_id, exit_code, event_type)
            logger.debug("terminal", "Terminal exited with code: " .. exit_code)
            if config.close_on_exit then
                M.close()
            end
        end,
    })

    if jobid <= 0 then
        logger.error("terminal", "Failed to start terminal job")
        return false
    end

    is_open = true

    if focus then
        vim.cmd("startinsert")
    end

    logger.debug("terminal", "Terminal opened successfully")
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

    if jobid then
        vim.fn.jobstop(jobid)
    end

    if winid and vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_close(winid, true)
    end

    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
    end

    cleanup_state()
    logger.debug("terminal", "Terminal closed")
    return true
end

--- Toggle terminal visibility
--- @param cmd_string string?
--- @param env_table table?
--- @param effective_config table?
--- @param focus boolean?
--- @return boolean
function M.toggle(cmd_string, env_table, effective_config, focus)
    if is_valid() and is_open then
        return M.close()
    else
        return M.open(cmd_string, env_table, effective_config, focus)
    end
end

--- Focus the terminal window
--- @return boolean
function M.focus()
    if not is_valid() then
        logger.warn("terminal", "No valid terminal to focus")
        return false
    end

    --- @cast winid -?
    vim.api.nvim_set_current_win(winid)
    vim.cmd("startinsert")
    return true
end

--- Send text to terminal
--- @param text string
--- @return boolean
function M.send_text(text)
    if not is_valid() or not jobid then
        logger.warn("terminal", "No active terminal to send text to")
        return false
    end

    vim.api.nvim_chan_send(jobid, text)
    logger.debug("terminal", "Sent text to terminal: " .. text)
    return true
end

--- Send command to terminal
--- @param command string
--- @return boolean
function M.send_command(command)
    if not is_valid() or not jobid then
        logger.warn("terminal", "No active terminal to send command to")
        return false
    end

    vim.api.nvim_chan_send(jobid, command .. "\n")
    logger.debug("terminal", "Sent command to terminal: " .. command)
    return true
end

--- Check if terminal is open
--- @return boolean
function M.is_open()
    return is_valid() and is_open
end

--- Get terminal buffer number
--- @return integer?
function M.get_bufnr()
    return bufnr
end

--- Get terminal window ID
--- @return integer?
function M.get_winid()
    return winid
end

--- Get terminal job ID
--- @return integer?
function M.get_jobid()
    return jobid
end

return M
