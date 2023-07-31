-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { '/usr/bin/tmux' }

-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#005566',
  inactive_titlebar_bg = '#334466',
}
config.colors = {
  tab_bar = {
    inactive_tab_edge = '#575757',
  }
}
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.8
config.font = wezterm.font 'JetBrains Mono'

-- and finally, return the configuration to wezterm
return config

