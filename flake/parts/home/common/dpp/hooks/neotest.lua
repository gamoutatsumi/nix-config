-- lua_add {{{
local neotest = require("neotest")
neotest.setup({
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
        require("neotest-plenary"),
    },
})

vim.keymap.set("n", "<leader>tt", neotest.run.run, { desc = "Run nearest teset" })
vim.keymap.set("n", "<leasder>tf", function()
    neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })
vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>to", function()
    neotest.output.open({ enter = true })
end, { desc = "Open test output" })
vim.keymap.set("n", "<leader>td", function()
    neotest.run.run({ suite = false, strategy = "dap" })
end, { desc = "Debug nearest test" })
-- }}}
