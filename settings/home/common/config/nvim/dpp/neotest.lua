-- lua_add {{{
require("neotest").setup({
    adapters = {
        require("neotest-go")({
            recursive_run = true,
            test_table = true,
        }),
    },
})
-- }}}
