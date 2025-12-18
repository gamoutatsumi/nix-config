local prettierd = require("efmls-configs.formatters.prettier_d")
local textlint = require("efmls-configs.linters.textlint")
local languages = {
    markdown = { textlint },
    tex = { textlint },
    javascript = { prettierd },
    typescript = { prettierd },
    typescriptreact = { prettierd },
    javascriptreact = { prettierd },
}

---@type vim.lsp.Config
return {
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
