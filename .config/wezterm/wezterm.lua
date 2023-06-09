-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on('update-right-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = query_appearance_gnome()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

config.color_scheme = 'Cyberdyne'
config.initial_rows = 120
config.initial_cols = 200
config.font_size = 13.0
config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'Nerd Font Symbols',
  'HackGen Console NFJ',
  'Noto Color Emoji',
}
config.window_background_gradient = {
  colors = { '#103000', '#0F295C', '#000000' },
  orientation = { Linear = { angle = -45 } }
}
config.background = {
  {
    source = {
      -- Gradient = { preset = 'Warm' },
      Color = '#000000',
    },
    opacity = 1,
  },
  {
    source = {
      File = '/usr/local/src/pictures/mikuv3_img2.png'
    },
    repeat_x = 'NoRepeat',
    vertical_align = 'Middle',
    attachment = 'Fixed',
    hsb = { brightness = 0.5 },
    opacity = 0.75,
  },
}

-- and finally, return the configuration to wezterm
return config
