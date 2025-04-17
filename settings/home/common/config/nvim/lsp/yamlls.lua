return {
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
}
