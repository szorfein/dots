local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()

local mytheme = {}

mytheme.name = "worker"

-- xrdb variables and fallback
mytheme.x = {
  background = xrdb.color0 or "#121212",
  foreground = xrdb.foreground or "#FDFDFD",
  surface = xrdb.color0 or "#000000",
  dark_primary = "#281f2c", -- branded dark surface

  primary = xrdb.color6 or "#9afff9", -- cyan
  primary_variant_1 = xrdb.color2 or "#aaff99", -- primary saturate (200-500)
  primary_variant_2 = xrdb.color4 or "#aaffe9", -- primary saturate (200-500)
  
  secondary = xrdb.color5 or "#daffe9", -- magenta
  secondary_variant_1 = xrdb.color3 or "#aafa66", -- magenta
  secondary_variant_2 = xrdb.color13 or "#efea8a", -- magenta
  
  error = xrdb.color1 or "#ff99bb",
  error_variant_1 = xrdb.color9 or "#CF6673",

  on_background = xrdb.color15 or "#ffffff", -- white
  on_surface = xrdb.color15,  -- white
  on_primary = xrdb.color0, -- black
  on_secondary = xrdb.color0,  -- black
  on_error = xrdb.color0, -- white
  on_surface = xrdb.color15
}

-- fonts
mytheme.f = {
  h1 = "Iosevka Light 60", -- used rarely on big icon or big title
  h4 = "Iosevka Regular 32",
  h6 = "Iosevka Regular 20",
  subtile_1 = "Iosevka Regular 12", -- used on text list
  body_1 = "Iosevka Term Regular 15", -- used on text body title
  body_2 = "Iosevka Term Light 13", -- used on text body
  -- for button, don't use a Mono variant because icons are too small
  -- issue: https://github.com/Powerlevel9k/powerlevel9k/issues/430
  button = "Iosevka Term Medium Nerd Font Complete 14", -- used on text button
  caption = "Iosevka Bold 12", -- used on annotation
  overline = "Iosevka Regular 10",
}

-- text emphasis
-- https://material.io/design/color/dark-theme.html#ui-application
mytheme.t = {
  high = 87,
  medium = 60,
  disabled = 38
}

-- elevation overlay transparency in hexa code
-- https://material.io/design/color/dark-theme.html#properties
mytheme.e = {
  dp00 = "00",
  dp01 = "0D",
  dp02 = "12",
  dp03 = "14",
  dp04 = "17",
  dp06 = "1C",
}

return mytheme
