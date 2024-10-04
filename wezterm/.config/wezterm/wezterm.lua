-- Pull wezterm API
local wezterm = require 'wezterm'

-- Holds configuration
local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 18.0

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.color_scheme = "Tokyo Night"

config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

return config
