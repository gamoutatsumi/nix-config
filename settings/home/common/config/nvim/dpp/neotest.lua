-- lua_add {{{
require("neotest").setup({
    adapters = {
        require("neotest-golang")({
            testify_enabled = true,
            runner = "gotestsum",
            go_test_args = {
                "-v",
                "-race",
                "-count=1",
                "-coverprofile=" .. vim.fn.getcwd() .. "/cover.out",
            },
        }),
    },
})
-- }}}
