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
return {
    autostart = true,
    cmd = { "efm-langserver", "-q" },
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
}
