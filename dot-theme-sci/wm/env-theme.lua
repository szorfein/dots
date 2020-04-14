local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()

local mytheme = {}

mytheme.x = {

  background = xrdb.color0 or "#121212",
  surface = xrdb.color0 or "#000000",
  dark_primary = "#172028", -- branded dark surface

  primary = xrdb.color6 or "#9afff9", -- cyan
  primary_variant_1 = xrdb.color2 or "#88EFAC", -- primary analog
  primary_variant_2 = xrdb.color4 or "#808FEC", -- primary analog

  secondary = xrdb.color5 or "#E686AC", -- magenta
  secondary_variant_1 = xrdb.color3 or "#DBA68C", -- secondary analog
  secondary_variant_2 = xrdb.color13 or "#EB86FC", -- secondary analog

  error = xrdb.color1 or "#BF96B3",
  error_variant_1 = xrdb.color9 or "#BFA6B3",

  on_background = xrdb.color15 or "#ffffff", -- white
  on_surface = xrdb.color15 or "#ffffff",  -- white
  on_primary = xrdb.color0 or "#111111", -- black
  on_secondary = xrdb.color0 or "#111111",  -- black
  on_error = xrdb.color0 or "#111111", -- black
  on_surface = xrdb.color15 or "#ffffff"
  
}

return mytheme
