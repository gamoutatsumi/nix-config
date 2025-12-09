-- lua_add {{{
require("neotest").setup({
    adapters = {
        require("neotest-golang")({
            testify_enabled = true,
        }),
    },
})
-- }}}
