return {
    settings = {
        Lua = {
            semantic = { enable = false },
        },
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
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
                version = "LuaJIT",
            },
            diagnostics = {
                enable = true,
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
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
        })
    end,
}
