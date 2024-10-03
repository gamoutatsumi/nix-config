local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end
config.font = wezterm.font_with_fallback({
    { family = "PlemolJP Console NF" },
    { family = "HackGen Console NF" },
})
config.font_size = 15.5
config.enable_tab_bar = true
config.unix_domains = {
    {
        name = "unix",
    },
}
config.default_gui_startup_args = { "connect", "unix" }
--config.default_prog = { "zsh", "--login" }
config.debug_key_events = true
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
return config
