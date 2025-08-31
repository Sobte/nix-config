-- the line is added to the home manager configuration file
-- local wezterm = require 'wezterm'
-- https://wezfurlong.org/wezterm/config/files.html
local config = {}

-- windows
config.initial_cols = 140
config.initial_rows = 40
config.enable_tab_bar = false
config.enable_scroll_bar = true

-- color
-- https://github.com/catppuccin/wezterm
function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Macchiato"
  else
    return "Catppuccin Frappe"
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- font
config.font_size = 10
-- https://harfbuzz.github.io/shaping-opentype-features.html
-- https://learn.microsoft.com/en-us/typography/opentype/spec/features_pt#tag-ss01---ss20
config.font = wezterm.font_with_fallback {
  {
    family = 'Iosevka Nerd Font Mono',
    weight = 'Regular',
  },
  {
    -- https://github.com/githubnext/monaspace
    family = 'Monaspace Neon',
    weight = 'Regular',
    harfbuzz_features = {
      'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss08',
      'calt', 'dlig',
    },
  },
  'NotoSansMono Nerd Font',
}

return config