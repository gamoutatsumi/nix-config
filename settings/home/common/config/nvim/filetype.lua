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
        ["dot_zshrc"] = "zsh",
        ["justfile"] = "make",
        ["tsconfig.json"] = "jsonc",
        ["xmobarrc"] = "haskell",
        -- keep-sorted end
    },
    pattern = {
        -- keep-sorted start
        [".swcrc*"] = "json",
        --keep-sorted end
    },
})
