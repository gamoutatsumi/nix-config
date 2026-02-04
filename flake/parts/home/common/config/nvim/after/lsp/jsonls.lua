local schemas = require("schemastore")
return {
    cmd = { "vscode-json-language-server", "--stdio" },
    settings = {
        json = {
            schemas = schemas.json.schemas(),
        },
    },
    init_options = {
        provideFormatter = true,
    },
}
