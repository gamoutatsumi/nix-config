---@type vim.lsp.Config
return {
    settings = {
        texlab = {
            build = {
                executable = "lualatex",
                args = { "-synctex=1", "%f" },
                onSave = false,
                forwardSearchAfter = false,
            },
            forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l%1:%f", "%p" },
            },
        },
    },
}
