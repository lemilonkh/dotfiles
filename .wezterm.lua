-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { "/usr/bin/tmux" }

-- config.color_scheme = 'AdventureTime'
-- config.color_scheme = "Gruvbox Dark (Gogh)"
config.color_scheme = "Catppuccin Mocha"
config.window_frame = {
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
	font_size = 12.0,
	active_titlebar_bg = "#005566",
	inactive_titlebar_bg = "#334466",
}
config.colors = {
	tab_bar = {
		inactive_tab_edge = "#575757",
	},
}
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.995
config.font = wezterm.font("JetBrains Mono")
config.warn_about_missing_glyphs = false

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = true

config.keys = {
	{
		key = "F11",
		-- mods = 'SHIFT|CTRL',
		action = wezterm.action.ToggleFullScreen,
	},
}

-- and finally, return the configuration to wezterm
return config
