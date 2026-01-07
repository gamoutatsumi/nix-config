-- lua_add {{{
require("codecompanion").setup({
    interactions = {
        chat = {
            adapter = "opencode",
        },
    },
    adapters = {
        acp = {
            opencode = function()
                return require("codecompanion.adapters").extend("opencode", {
                    commands = {
                        -- The default uses the opencode/config.json value
                        default = {
                            "opencode",
                            "acp",
                        },
                        anthropic_sonnet_4_5 = {
                            "opencode",
                            "acp",
                            "-m",
                            "anthropic/claude-sonnet-4.5",
                        },
                        anthropic_opus_4_5 = {
                            "opencode",
                            "acp",
                            "-m",
                            "anthropic/claude-opus-4.5",
                        },
                    },
                })
            end,
        },
    },
})
--}}}
