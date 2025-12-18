---@type vim.lsp.Config
return {
    root_dir = function(bufnr, on_dir)
        -- The project root is where the LSP can be started from
        -- As stated in the documentation above, this LSP supports monorepos and simple projects.
        -- We select then from the project root, which is identified by the presence of a package
        -- manager lock file.
        local root_markers = { "node_modules" }
        -- Give the root markers equal priority by wrapping them in a table
        root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers } or root_markers
        local project_root = vim.fs.root(bufnr, root_markers)
        if not project_root then
            return
        end

        on_dir(project_root)
    end,
    settings = {
        javascript = {
            preferGoToSourceDefinition = true,
            suggest = {
                autoImports = false,
            },
        },
        typescript = {
            preferGoToSourceDefinition = true,
            suggest = {
                completeFunctionCalls = true,
                autoImports = false,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
                variableTypes = {
                    enabled = true,
                },
                propertyDeclarationTypes = {
                    enabled = true,
                },
                functionLikeReturnTypes = {
                    enabled = true,
                },
                enumMemberValues = {
                    enabled = true,
                },
                parameterTypes = {
                    enabled = true,
                },
            },
        },
    },
}
