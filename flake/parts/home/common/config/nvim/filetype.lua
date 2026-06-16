vim.filetype.add({
    extension = {
        -- keep-sorted start
        als = "alloy",
        astro = "astro",
        cue = "cue",
        gotmpl = "gotmpl",
        j2 = "jinja",
        jsonnet = "jsonnet",
        saty = "satysfi",
        satyh = "satysfi",
        service = "systemd",
        tf = "terraform",
        ts = "typescript",
        txt = "text",
        -- keep-sorted end
    },
    filename = {
        -- keep-sorted start
        [".eslintignore"] = "gitignore",
        [".swcrc"] = "json",
        [".textlintrc"] = "json",
        ["Tiltfile"] = "starlark",
        ["buf.gen.yaml"] = "buf-config",
        ["buf.lock"] = "buf-config",
        ["buf.policy.yaml"] = "buf-config",
        ["buf.yaml"] = "buf-config",
        ["dot_zshrc"] = "zsh",
        ["justfile"] = "make",
        ["tsconfig.json"] = "jsonc",
        -- keep-sorted end
    },
    pattern = {
        -- keep-sorted start
        [".swcrc*"] = "json",
        --keep-sorted end
    },
})
