local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()

local mytheme = {}

mytheme.name = "connected"

mytheme.x = {
  background = xrdb.color0 or "#121212",
  foreground = xrdb.foreground or "#FDFDFD",
  surface = xrdb.color0 or "#000000",
  dark_primary = "#1d2e23", -- branded dark surface

  primary = xrdb.color14 or "#52dcba", -- cyan
  primary_variant = xrdb.color6 or "#009F6C", -- primary saturate (200-500)
  error = xrdb.color9 or "#CF6673",

  secondary = xrdb.color13 or "#BB86FC", -- magenta

  on_background = xrdb.foreground or "#ffffff", -- white
  on_surface = xrdb.color15,  -- white
  on_primary = xrdb.color0, -- black
  on_secondary = xrdb.color0,  -- black
  on_error = xrdb.color0, -- white
  on_surface = xrdb.color15
}

mytheme.f = {
  h1 = "Roboto Mono Light Nerd Font Complete 60", -- used rarely on big icon or big title
  h4 = "Roboto Mono Nerd Font Complete 32",
  h5 = "Material Design Icons Regular 20", -- icon for h6
  h6 = "Roboto Mono Medium Nerd Font Complete 20",
  subtile_1 = "Roboto Mono Nerd Font Complete Mono 13", -- used on text list
  body_1 = "Roboto Mono Bold Nerd Font Complete 16", -- used on text body title
  body_2 = "Roboto Mono Nerd Font Complete 14", -- used on text body
  icon = "Material Design Icons Regular 15", -- used for icon
  button = "Roboto Mono Bold Nerd Font Complete 14", -- used on text button
  caption = "Roboto Mono Bold Nerd Font Complete 12", -- used on annotation
  overline = "Roboto Mono Nerd Font Complete Mono 10",
}

mytheme.t = {
  high = 87,
  medium = 60,
  disabled = 38
}

mytheme.e = {
  dp00 = "00", -- 0%
  dp01 = "0D", -- 5%
  dp02 = "12", -- 7%
  dp03 = "14", -- 8%
  dp04 = "17", -- 9%
  dp06 = "1C", -- 11%
}

return mytheme
