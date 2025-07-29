---@type vim.lsp.Config
return {
    workspace_required = true,
    root_markers = { "deno.json", "deno.jsonc" },
    settings = {
        typescript = {
            suggest = {
                completeFunctionCalls = true,
                autoImports = false,
            },
            lint = true,
            unstable = true,
            editor = {
                inlayHints = {
                    enabled = true,
                },
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
