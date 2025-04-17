return {
    settings = {
        fennel = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_list_runtime_paths(),
            },
        },
    },
}
