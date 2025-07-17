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
local tip_down = false
local config = {}

local function cleanup_state()
    bufnr = nil
    winid = nil
    jobid = nil
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
                logger.debug("ternmal", "Recovered terminal window ID:" .. win)
                return true
            end
        end
        return true
    end
    return true
end

local function open_terminal(cmd_string, env_table, effective_config, focus)
    focus = utils.normalize_focus(focus)
    if is_valid() then
        --- @cast winid -?
        if focus then
            vim.api.nvim_set_current_win(winid)
            vim.cmd("startinsert")
        end
    end
    return true
end
