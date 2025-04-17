return {
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
