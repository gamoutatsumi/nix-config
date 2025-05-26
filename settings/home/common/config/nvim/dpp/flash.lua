--- lua_add {{{
require("flash").setup({
    modes = {
        char = {
            enabled = true,
            keys = { "f", "F", "t", "T" },
            multi_line = false,
            autohide = true,
            jump_labels = true,
            char_actions = function(motion)
                return {
                    [motion:lower()] = "next",
                    [motion:upper()] = "prev",
                }
            end,
            search = { wrap = false },
            highlight = { backdrop = false },
            jump = { register = false },
        },
    },
})
--- }}}
