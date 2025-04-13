-- lua_add {{{
local lspconfig = require("lspconfig")
local schemas = require("schemastore")

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

require("ddc_source_lsp_setup").setup({ override_capabilities = true, respect_trigger = true })

local on_attach = function(client, bufnr)
    local function format()
        local formatOpts = {
            filter = function(formatterClient)
                return formatterClient.name ~= "tsserver"
            end,
        }
        vim.lsp.buf.format(formatOpts)
    end
    vim.diagnostic.config({
        virtual_lines = true,
        virtual_text = false,
        float = false,
        underline = true,
    })
    vim.b.copilot_workspace_folder = vim.lsp.buf.list_workspace_folders()[1]
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = false })
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = false })
    end, opts)
    vim.keymap.set("n", "<Leader>f", format, opts)
    vim.keymap.set("n", "<Leader>ld", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, opts)
    require("lsp_signature").on_attach({
        bind = true,
        handler_opts = {
            border = "rounded",
        },
    }, bufnr)
    if client:supports_method("textDocument/inlayHint") or client.name == "sourcekit" then
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

vim.lsp.config("*", { on_attach = on_attach })

vim.lsp.config("yamlls", {
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
})

vim.lsp.config("unocss", {
    cmd = { "./node_modules/.bin/unocss-language-server", "--stdio" },
})
vim.lsp.enable("unocss")

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {},
    },
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                version = "LuaJIT",
            },
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
            format = {
                enable = false,
            },
            telemetry = {
                enable = false,
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        })
    end,
})
vim.lsp.enable("lua_ls")

if vim.fn.executable("./node_modules/.bin/biome") == 1 then
    vim.lsp.config("biome", {
        cmd = { "./node_modules/.bin/biome", "lsp" },
    })
end

vim.lsp.enable("biome")

lspconfig.astro.setup({
    on_attach = on_attach,
    autostart = true,
})

if vim.fn.executable("typescript-language-server") == 1 then
    vim.lsp.enable("ts_ls")
end

if vim.fn.executable("vtsls") == 1 then
    vim.lsp.config("vtsls", {
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
    vim.lsp.enable("vtsls")
end

if vim.fn.executable("typescript-language-server") == 0 and vim.fn.executable("vtsls") == 0 then
    vim.lsp.config("denols", {
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
    vim.lsp.enable("denols")
end

vim.lsp.enable("hls")

vim.lsp.enable("nil_ls")

vim.lsp.config("sourcekit", {
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
vim.lsp.enable("sourcekit")

require("go").setup({
    filstruct = "gopls",
    dap_debug = true,
    dap_debug_gui = true,
    lsp_inlay_hints = { enable = false },
})

vim.lsp.config("gopls", {
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
vim.lsp.enable("gopls")

vim.lsp.config("jsonls", {
    settings = {
        json = {
            schemas = schemas.json.schemas(),
        },
    },
    init_options = {
        provideFormatter = true,
    },
})
vim.lsp.enable("jsonls")

local eslint_d = require("efmls-configs.linters.eslint_d")
local prettierd = require("efmls-configs.formatters.prettier_d")
local languages = {
    python = {
        require("efmls-configs.formatters.ruff"),
        require("efmls-configs.linters.ruff"),
    },
    lua = {
        require("efmls-configs.formatters.stylua"),
    },
    dockerfile = {
        require("efmls-configs.linters.hadolint"),
    },
    sh = {
        require("efmls-configs.linters.shellcheck"),
        require("efmls-configs.formatters.shfmt"),
    },
    javascript = { eslint_d, prettierd },
    typescript = { eslint_d, prettierd },
    typescriptreact = { eslint_d, prettierd },
    javascriptreact = { eslint_d, prettierd },
    nix = {
        require("efmls-configs.linters.statix"),
    },
}
lspconfig.efm.setup({
    autostart = true,
    cmd = { "efm-langserver", "-q" },
    on_attach = on_attach,
    filetypes = vim.tbl_keys(languages),
    settings = {
        rootMarkers = { ".git/" },
        languages = languages,
        logLevel = 3,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
})

vim.lsp.enable("terraformls")

vim.lsp.enable("pyright")

vim.lsp.enable("rust_analyzer")

vim.lsp.config("fennel_language_server", {
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
vim.lsp.enable("fennel_language_server")
-- }}}
