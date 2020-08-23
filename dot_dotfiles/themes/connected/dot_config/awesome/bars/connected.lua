local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = require('beautiful').xresources.apply_dpi
local separators = require('util.separators')
local widget = require('util.widgets')

-- widgets load
local hostname = require("widgets.hostname")
local scrot = require("widgets.scrot")
local pad = separators.pad
local arrow = separators.arrow_left

-- gradient colors (dark to light)
local g0 = M.x.background
local g1 = M.x.dark_primary
local g2 = M.x.primary
local g3 = M.x.secondary

-- {{{ Add a background to the widgets

local tor = require("widgets.button_tor")
local my_tor = widget.bg( g1, tor )

local network = require("widgets.network")({
  mode = "ip", fg = M.x.on_primary, icon_ip = { "", M.x.on_primary }
})
local my_network = widget.bg( g2, network )

local wifi_str = require("widgets.wifi_str")
local my_wifi_str = widget.bg( g3, wifi_str )

local mpc = require("widgets.mpc")({ colors = { beautiful.primary, beautiful.primary } })
local my_mpc_widget = widget.bg( g1, mpc )

local my_volume = require("widgets.volume")({
  fg = M.x.on_primary, icon = { "", M.x.on_primary }, bg = g2
})

local change_theme = require("widgets.button_change_theme")
local my_change_theme = widget.bg( g1, change_theme )

local ram = require("widgets.ram")({})
local my_ram = widget.bg( g1, ram )

local my_battery = require("widgets.battery")({
  fg = M.x.on_secondary, bg = g3, icon = { "臘", M.x.on_secondary }
})

local mail = require("widgets.mail")
local my_email = widget.bg( g2, mail )

local date = require("widgets.date")
local my_date = widget.bg( g1, date_widget )

-- }}} End widget

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil

  return function() 
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ theme = { width = 250 } })
    end
  end
end
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

local mybar = class()

-- Add the bar on each screen
function mybar:init(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  s.mytaglist = require("widgets.taglist")(s, { mode = "text" })

  -- Create the wibox with default options
  s.mywibox = awful.wibar({ position = top, height = beautiful.wibar_size, bg = beautiful.wibar_bg, screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      --mylauncher,
      s.mypromptbox,
      distrib_icon,
      s.mytaglist,
    },
    { -- More or less Middle
      pad(5),
      arrow(g0, g1),
      my_tor,
      arrow(g1, g2),
      my_network,
      arrow(g2, g3),
      my_wifi_str,
      arrow(g3, g0),
      pad(28),
      arrow(g0, g1),
      my_mpc_widget,
      arrow(g1, g2),
      my_volume,
      arrow(g2, g1),
      my_change_theme,
      arrow(g1, g0),
      layout = wibox.layout.fixed.horizontal
    },
    { -- Right widgets
      mykeyboardlayout,
      arrow(g0, g1),
      my_ram,
      arrow(g1, g3),
      my_battery,
      arrow(g3, g2),
      my_email,
      arrow(g2, g1),
      my_date,
      arrow(g1, g0),
      scrot,
      wibox.widget.systray(),
      layout = wibox.layout.fixed.horizontal,
    },
  }
end

return mybar
