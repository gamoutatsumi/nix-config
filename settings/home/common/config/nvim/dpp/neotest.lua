-- lua_add {{{
require("neotest").setup({
    adapters = {
        require("neotest-go")({
            recursive_run = true,
            experimental = {
                test_table = true,
            },
        }),
    },
})
-- }}}
