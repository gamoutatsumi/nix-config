-- lua_add {{{
require("neotest").setup({
    adapters = {
        require("neotest-golang")({}),
    },
})
-- }}}
