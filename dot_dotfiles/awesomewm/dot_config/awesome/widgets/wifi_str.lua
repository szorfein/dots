local awful = require("awful")
local beautiful = require("beautiful")
local widget = require("util.widgets")
local helpers = require("helpers")
local font = require("util.font")

-- beautiful vars
local fg = beautiful.widget_wifi_str_fg
local bg = beautiful.widget_wifi_str_bg
local l = beautiful.widget_wifi_layout or 'horizontal'
local spacing = beautiful.widget_spacing or 1

-- widget creation
local text = font.body_text("")
local wifi_str_widget = widget.box_with_margin(l, { text }, spacing)

awful.widget.watch(
  os.getenv("HOME").."/.config/awesome/widgets/network.sh wifi", 60,
  function(widget, stdout, stderr, exitreason, exitcode)
    local filter_wifi = stdout:match('%d+')
    local wifi_str = tonumber(filter_wifi) or 0
    if (wifi_str ~= "0") then
      text.markup = helpers.colorize_text(filter_wifi..'%', fg)
    end
  end
)

return wifi_str_widget
