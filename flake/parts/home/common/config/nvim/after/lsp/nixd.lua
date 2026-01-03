---@type vim.lsp.Config
return {
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }",
            },
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
}
