-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font_with_fallback {
  'Dank Mono',
  'JetBrains Mono',
  'Nerd Font Symbols',
  'Noto Color Emoji'
}
config.font_size = 16

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.enable_scroll_bar = true

config.send_composed_key_when_left_alt_is_pressed = true

-- and finally, return the configuration to wezterm
return config
