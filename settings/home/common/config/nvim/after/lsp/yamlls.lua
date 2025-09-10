return {
    settings = {
        yaml = {
            schemaStore = {
                enable = true,
            },
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.3-standalone-strict/all.json"] = "/*.k8s.yaml",
                ["https://www.schemastore.org/github-action.json"] = "action.{yml,yaml}",
                ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] = "/roles/*/tasks/*.{yml,yaml}",
                ["https://taskfile.dev/schema.json"] = "Taskfile.{yml,yaml}",
            },
        },
    },
}
