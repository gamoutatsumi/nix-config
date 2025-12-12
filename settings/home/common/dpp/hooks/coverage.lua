-- lua_add {{{
require("coverage").setup({
    lang = {
        go = {
            coverage_file = "cover.out",
        },
    },
})
--}}}
