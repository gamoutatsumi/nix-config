-- lua_add {{{
local builtin = require("statuscol.builtin")
require("statuscol").setup({
    bt_ignore = { "terminal", "nofile", "ddu-ff", "ddu-ff-filter", "fern" },

    relculright = true,
    segments = {
        {
            sign = {
                namespace = { "gitsigns" },
                maxwidth = 1,
                colwidth = 1,
            },
        },
        {
            sign = { name = { "coverage" } },
            maxwidth = 1,
            colwidth = 1,
            auto = true,
        },
        {
            sign = {
                name = { "DapBreakpoint.*" },
                maxwidth = 1,
                colwidth = 1,
                auto = true,
            },
        },
        {
            sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
        },
        {
            text = { builtin.lnumfunc },
        },
        { text = { "│" } },
    },
})
-- }}}
