local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()

local mytheme = {}

mytheme.name = "anonymous"

mytheme.x = {
  background = xrdb.color0 or "#121212",
  foreground = xrdb.foreground or "#FDFDFD",
  surface = xrdb.color0 or "#000000",
  dark_primary = "#222F3C", -- branded dark surface

  primary = xrdb.color14 or "#52dcba", -- cyan
  primary_variant = xrdb.color6 or "#009F6C", -- primary saturate (200-500)
  error = xrdb.color9 or "#CF6673",

  secondary = xrdb.color13 or "#BB86FC", -- magenta

  on_background = xrdb.color15 or "#ffffff", -- white
  on_surface = xrdb.color15,  -- white
  on_primary = "#000000", -- black
  on_secondary = "#000000",  -- black
  on_error = "#ffffff", -- white
  on_surface = "#ffffff"
}

-- fonts
mytheme.f = {
  h1 = "Iosevka Light 60", -- used rarely on big icon or big title
  h4 = "Iosevka Regular 32",
  h6 = "Iosevka Regular 20",
  subtile_1 = "Iosevka Regular 13", -- used on text list
  body_1 = "Iosevka Term Regular 16", -- used on text body title
  body_2 = "Iosevka Term Light 14", -- used on text body
  button = "Iosevka Term Medium Nerd Font Complete 13", -- used on text button
  caption = "Iosevka Bold 12", -- used on annotation
  overline = "Iosevka Regular 10",
}

-- text emphasis
mytheme.t = {
  high = 87,
  medium = 60,
  disabled = 38
}

-- elevation overlay
mytheme.e = {
  dp00 = "00",
  dp01 = "0D",
  dp02 = "12",
  dp03 = "14",
  dp04 = "17",
  dp06 = "1C",
}

return mytheme
