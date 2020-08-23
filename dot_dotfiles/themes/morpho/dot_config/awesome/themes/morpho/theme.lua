---------------------------
-- Morpho awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local gshape = require("gears.shape")
local themes_path = gfs.get_themes_dir()
local layout_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. M.name .. "/layouts/"
local xrdb = xresources.get_current_theme()
local wibox = require("wibox")
local taglist_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. M.name .. "/taglist/"

local theme = {}

theme.border_width  = dpi(1)
theme.screen_margin = dpi(6)
theme.useless_gap   = dpi(4)
theme.border_normal = M.x.background
theme.border_focus  = M.x.background
theme.border_radius = dpi(18)

-- general padding
theme.general_padding = { left = dpi(0), right = dpi(0), top = dpi(0), bottom = dpi(0) }

-- smart border
theme.double_border = false

-- Gravities
theme.gravity_ncmpcpp = { 16, 12, 31, 45 }
theme.gravity_cava = { 16, 61, 31, 19 }
theme.gravity_music_term = { 49, 12, 34, 68 }

-- Top bar
theme.wibar_border_radius = dpi(0)
theme.wibar_height = dpi(40)

-- {{{ TAGLIST

-- Nerd Font icon here
theme.tagnames = {" 1 "," 2 "," 3 "," 4 "," 5 "," 6 "," 7 "," 8 "," 9 "," 10 "}

-- different color on each taglists
theme.taglist_text_color_empty = {
  M.x.on_background .. M.e.dp01,
  M.x.on_background .. M.e.dp02,
  M.x.on_background .. M.e.dp03,
  M.x.on_background .. M.e.dp04,
  M.x.on_background .. M.e.dp06,
  M.x.on_background .. M.e.dp01,
  M.x.on_background .. M.e.dp02,
  M.x.on_background .. M.e.dp03,
  M.x.on_background .. M.e.dp04,
  M.x.on_background .. M.e.dp06,
}

theme.taglist_text_color_occupied = {
  M.x.secondary .. "66",
  M.x.secondary .. "69",
  M.x.secondary .. "6B",
  M.x.secondary .. "6E",
  M.x.secondary .. "70",
  M.x.secondary .. "73",
  M.x.secondary .. "75",
  M.x.secondary .. "78",
  M.x.secondary .. "7A",
  M.x.secondary .. "7D",
}

theme.taglist_text_color_focused = {
  M.x.primary,
  M.x.secondary,
  M.x.primary,
  M.x.secondary,
  M.x.primary,
  M.x.secondary,
  M.x.primary,
  M.x.secondary,
  M.x.primary,
  M.x.secondary,
}

theme.taglist_text_color_urgent = {
  M.x.error .. "66",
  M.x.error .. "69",
  M.x.error .. "6B",
  M.x.error .. "6E",
  M.x.error .. "70",
  M.x.error .. "73",
  M.x.error .. "75",
  M.x.error .. "78",
  M.x.error .. "7A",
  M.x.error .. "7B",
}

-- icon_taglist
theme.ntags = 10

theme.taglist_layout = wibox.layout.fixed.horizontal -- horizontal or vertical

-- }}} TAGLIST END

-- {{{ MENU

theme.menu_height = dpi(16)
theme.menu_width  = dpi(100)

-- }}} End MENU

theme.wallpaper = os.getenv("HOME").."/images/"..M.name..".jpg"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
  theme.menu_height, M.x.secondary, M.x.on_secondary
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
--theme.icon_theme = nil
theme.icon_theme = nil

-- {{{ WIDGETS

theme.widget_spacing = dpi(20) -- space between each widgets
-- popup (distance between the bar and the popup, 0 is pasted at the bar)
theme.widget_popup_padding = dpi(3)

-- Wifi str
theme.widget_wifi_str_fg = "#87aaaa"
theme.widget_wifi_str_bg = M.x.background
theme.widget_wifi_layout = 'horizontal' -- horizontal or vertical

-- Button mpc
theme.widget_mpc_button_icon = "ﱘ"

-- progressbar colors
theme.bar_color = M.x.primary
theme.bar_colors_disk = { M.x.primary, M.x.primary, M.x.primary }
theme.bar_colors_network = { M.x.primary, M.x.primary }

-- }}} End WIDGET

return theme
