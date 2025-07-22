-- lua_source {{{
local function skkstatus()
    local alias = { [""] = "A", hira = "あ", kata = "ア", hankata = "ｱ", zenkaku = "Ａ", abbrev = "@" }
    return alias[vim.g["skkeleton#mode"]]
end

local custom_nightfly = require("lualine.themes.nightfly")
custom_nightfly.insert.a.bg = custom_nightfly.normal.a.bg
custom_nightfly.visual.a.bg = custom_nightfly.normal.a.bg
custom_nightfly.normal.y = {}
custom_nightfly.normal.y.bg = custom_nightfly.normal.a.bg
custom_nightfly.normal.y.fg = custom_nightfly.normal.a.fg
custom_nightfly.insert.y = {}
custom_nightfly.insert.y.bg = custom_nightfly.normal.a.bg
custom_nightfly.insert.y.fg = custom_nightfly.normal.a.fg
custom_nightfly.normal.y = {}
custom_nightfly.normal.y.bg = custom_nightfly.normal.a.bg
custom_nightfly.normal.y.fg = custom_nightfly.normal.a.fg
custom_nightfly.command = {}
custom_nightfly.command.y = {}
custom_nightfly.command.y.bg = custom_nightfly.normal.a.bg
custom_nightfly.command.y.fg = custom_nightfly.normal.a.fg
custom_nightfly.insert.z = custom_nightfly.normal.b
custom_nightfly.normal.z = custom_nightfly.normal.b
custom_nightfly.command.z = custom_nightfly.normal.b
local function mcphub_section()
    -- Check if MCPHub is loaded
    if not vim.g.loaded_mcphub then
        return "󰐻 -"
    end

    local count = vim.g.mcphub_servers_count or 0
    local status = vim.g.mcphub_status or "stopped"
    local executing = vim.g.mcphub_executing

    -- Show "-" when stopped
    if status == "stopped" then
        return "󰐻 -"
    end

    -- Show spinner when executing, starting, or restarting
    if executing or status == "starting" or status == "restarting" then
        local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local frame = math.floor(vim.loop.now() / 100) % #frames + 1
        return "󰐻 " .. frames[frame]
    end

    return "󰐻 " .. count
end
local function mcphub_color()
    if not vim.g.loaded_mcphub then
        return { fg = "#6c7086" } -- Gray for not loaded
    end

    local status = vim.g.mcphub_status or "stopped"
    if status == "ready" or status == "restarted" then
        return { fg = "#50fa7b" } -- Green for connected
    elseif status == "starting" or status == "restarting" then
        return { fg = "#ffb86c" } -- Orange for connecting
    else
        return { fg = "#ff5555" } -- Red for error/stopped
    end
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = custom_nightfly,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode", skkstatus },
        lualine_b = {
            { "branch", separator = "", padding = { left = 1, right = 0 } },
            { "diff", colored = false, separator = "" },
            { "filename", path = 1, shorting_target = 30, icon_enabled = true, icon = "" },
        },
        lualine_c = {},
        lualine_x = {
            { mcphub_section, color = mcphub_color },
            "filetype",
            { "encoding", separator = "", padding = { left = 1, right = 0 } },
            "fileformat",
        },
        lualine_y = { { "location", separator = "" }, { "progress", padding = { left = 0, right = 1 } } },
        lualine_z = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                colored = false,
                symbols = { error = "E:", warn = "W:", info = "I", hint = "H:" },
            },
        },
    },
    extensions = { "fern" },
})
vim.go.laststatus = 0
-- }}}
