---@type vim.lsp.Config
return {
    settings = {
        typescript = {
            suggest = {
                completeFunctionCalls = true,
                autoImports = false,
                imports = {
                    hosts = {
                        ["https://deno.land"] = true,
                        ["https://x.nest.land"] = false,
                    },
                },
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
