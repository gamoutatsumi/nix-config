-- lua_add {{{
local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local schemas = require("schemastore")
local util = require("lspconfig/util")

local buf_name = vim.api.nvim_buf_get_name(0) == "" and vim.fn.getcwd() or vim.api.nvim_buf_get_name(0)
local is_node_repo = util.find_node_modules_ancestor(buf_name) ~= nil

local function setInlayHintHL()
    local has_hl, hl = pcall(vim.api.nvim_get_hl, 0, { name = "LspInlayHint" })
    if has_hl and (hl["fg"] or hl["bg"]) then
        return
    end

    hl = vim.api.nvim_get_hl(0, { name = "Comment" })
    local foreground = string.format("#%06x", hl["fg"] or 0)
    if #foreground < 3 then
        foreground = ""
    end

    hl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
    local background = string.format("#%06x", hl["bg"] or 0)
    if #background < 3 then
        background = ""
    end

    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = foreground, bg = background })
end

require("ddc_source_lsp_setup").setup()

local on_attach = function(client, bufnr)
    local function format()
        local formatOpts = {
            filter = function(formatterClient)
                return formatterClient.name ~= "tsserver"
            end,
        }
        vim.lsp.buf.format(formatOpts)
    end
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<Leader>f", format, opts)
    require("lsp_signature").on_attach({
        bind = true,
        handler_opts = {
            border = "rounded",
        },
    }, bufnr)
    if client.supports_method("textDocument/inlayHint") or client.name == "sourcekit" then
        setInlayHintHL()
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end,
        })
        vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end,
        })
        local timer = vim.uv.new_timer()
        timer:start(
            100,
            0,
            vim.schedule_wrap(function()
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end)
        )
    end
end

mason.setup()
mason_lspconfig.setup({})

lspconfig.yamlls.setup({
    autostart = true,
    settings = {
        yaml = {
            schemaStore = {
                enable = true,
            },
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.3-standalone-strict/all.json"] = "/*.k8s.yaml",
            },
        },
    },
    on_attach = on_attach,
})

lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    init_options = {
        provideFormatter = false,
    },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
            diagnostics = {
                enable = true,
                globals = { "vim" },
            },
            completion = {
                callSnippet = "Replace",
            },
            hint = {
                enable = true,
            },
            workspace = {
                library = vim.api.nvim_list_runtime_paths(),
            },
        },
    },
})

lspconfig.denols.setup({
    on_attach = on_attach,
    autostart = not is_node_repo,
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
})

lspconfig.hls.setup({
    on_attach = on_attach,
    autostart = true,
})

lspconfig["nixd"].setup({
    on_attach = on_attach,
    autostart = true,
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
    settings = {
        nixd = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
})

-- require("typescript").setup({
--   disable_commands = false,
--   debug = false,
--   go_to_source_definition = {
--     fallback = true,
--   },
--   server = {
--     autostart = is_node_repo,
--     on_attach = function(client, bufnr)
--       on_attach(client, bufnr)
--       client.server_capabilities.document_formatting = false
--     end,
--     settings = {
--       javascript = {
--         format = {
--           enable = false,
--         },
--       },
--       typescript = {
--         format = {
--           enable = false,
--         },
--         tsserver = {
--           useSyntaxServer = false,
--         },
--       },
--     },
--   },
-- })

lspconfig.sourcekit.setup({
    on_attach = on_attach,
    autostart = true,
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
    cmd = {
        "xcrun",
        "sourcekit-lsp",
        "-Xswiftc",
        "-sdk",
        "-Xswiftc",
        vim.fn.trim(vim.fn.system("xcrun --show-sdk-path --sdk iphonesimulator")),
        "-Xswiftc",
        "-target",
        "-Xswiftc",
        "arm64-apple-ios17.5-simulator",
    },
})

require("go").setup({
    filstruct = "gopls",
    dap_debug = true,
    dap_debug_gui = true,
    lsp_inlay_hints = { enable = false },
})

lspconfig.vtsls.setup({
    autostart = is_node_repo,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.document_formatting = false
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
})

lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.document_formatting = false
    end,
    settings = {
        gopls = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableypes = true,
            },
        },
    },
})

lspconfig.jsonls.setup({
    filetypes = { "json", "jsonc" },
    settings = {
        json = {
            schemas = schemas.json.schemas(),
        },
    },
    init_options = {
        provideFormatter = true,
    },
})

lspconfig.efm.setup({
    autostart = true,
    cmd = { "efm-langserver", "-q" },
    init_options = {
        documentFormatting = true,
        completion = false,
        rangeFormatting = true,
        hover = false,
        documentSymbol = true,
        codeAction = true,
    },
})

lspconfig.terraformls.setup({
    autostart = true,
    on_attach = on_attach,
})

lspconfig.fennel_language_server.setup({
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
})
-- }}}
