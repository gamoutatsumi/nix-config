local schemas = require("schemastore")
return {
    settings = {
        json = {
            schemas = schemas.json.schemas(),
        },
    },
    init_options = {
        provideFormatter = true,
    },
}
