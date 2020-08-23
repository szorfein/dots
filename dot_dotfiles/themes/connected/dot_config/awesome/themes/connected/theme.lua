---------------------------
-- Connected awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local layout_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. M.name .. "/layouts/"
local wibox = require("wibox")

local theme = {}

theme.border_width  = dpi(2)
theme.screen_margin = dpi(6)
theme.useless_gap   = dpi(0)
theme.border_normal = M.x.primary
theme.border_focus  = M.x.secondary

-- general padding
theme.general_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- rounded corners
theme.border_radius = dpi(8)

-- {{{ TITLEBAR 

theme.titlebars_enabled = true 
theme.titlebar_title_enabled = true 

-- }}} End TITLEBAR

-- Top bar
theme.wibar_size = dpi(23)
theme.wibar_bg = M.x.background
theme.wibar_border_radius = dpi(0)

-- Edge snap
theme.snap_bg = theme.bg_focus
if theme.border_width == 0 then
    theme.snap_border_width = dpi(8)
else
    theme.snap_border_width = dpi(theme.border_width * 2)
end

-- {{{ TAGLIST

-- mini_taglist
-- Nerd Font icon here
theme.tagnames = {"1","2","3","4","5","6","7","8","9","10"}
theme.taglist_text_occupied = {"","","ﲵ","ﱘ","","","","","","ﮊ"}
theme.taglist_text_focused = {"","","ﲵ","ﱘ","","","","","","ﮊ"}
theme.taglist_text_urgent = {"","","ﲵ","ﱘ","","","","","","ﮊ"}
theme.taglist_text_empty = {"","","ﲵ","ﱘ","","","","","","ﮊ"}

-- different color on each taglists
theme.taglist_text_color_empty = {
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
}

theme.taglist_text_color_occupied = {
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

theme.taglist_text_color_focused = {
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
  M.x.on_background,
}

theme.taglist_text_color_urgent = {
  M.x.error,
  M.x.error,
  M.x.error,
  M.x.error,
  M.x.error,
  M.x.error,
  M.x.error,
  M.x.error,
  M.x.error,
  M.x.error,
}

-- Text Taglist (default)
theme.taglist_disable_icon = true
theme.taglist_spacing = dpi(0)
theme.taglist_item_roundness = dpi(5)

theme.taglist_squares = "false"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
  taglist_square_size, theme.fg_focus
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
  taglist_square_size, theme.fg_normal
)

-- }}} TAGLIST END

-- {{{ MENU

theme.menu_submenu_icon = themes_path..M.name.."/submenu.png"
theme.menu_height = dpi(16)
theme.menu_width  = dpi(100)

-- }}} End MENU

theme.wallpaper = os.getenv("HOME") .. "/images/"..M.name..".jpg"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
  theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- {{{ WIDGET

theme.widget_spacing = dpi(6)

-- popup 
theme.widget_popup_padding = dpi(3)

-- Wifi str
theme.widget_wifi_str_fg = M.x.on_primary
theme.widget_wifi_str_bg = M.x.primary

theme.widget_ncmpcpp_prev = '  '
theme.widget_ncmpcpp_toggle = '  '
theme.widget_ncmpcpp_next = '  '

-- mpc
theme.widget_mpc_fg = M.x.primary

-- progressbar colors
theme.bar_color = M.x.primary
theme.bar_colors_disk = { M.x.primary, M.x.primary, M.x.primary }
theme.bar_colors_network = { M.x.primary, M.x.primary }
--

-- }}} End WIDGET

return theme
