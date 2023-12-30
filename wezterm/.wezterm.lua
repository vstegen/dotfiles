local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font({ family = "PragmataPro Mono" })
config.font_size = 15.0
config.color_scheme = "Catppuccin Mocha"
config.line_height = 1.1
-- config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true

return config
