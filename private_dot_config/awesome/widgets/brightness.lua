local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local button = require("utils.button")
local font = require("utils.font")
local slider = require("utils.slider")

local brightness_root = class()

function brightness_root:init()
  self.slider = slider.horiz()
  self.w = button({
    fg_icon = M.x.secondary,
    icon = font.icon(""),
    command = self.cmd,
    layout = "horizontal",
    margins = dpi(4),
  })
  self:gen_popup()
  self:signals()
end

function brightness_root:gen_popup()
  local w = awful.popup {
    widget = {
      {
        nil,
        {
          self.slider,
          forced_height = dpi(6),
          layout = wibox.layout.fixed.vertical
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      expand = "none",
      forced_height = dpi(200),
      forced_width = dpi(200),
      layout = wibox.layout.align.horizontal
    },
    hide_on_right_click = true,
    visible = false,
    ontop = true,
    bg = M.x.surface,
  }
  w:bind_to_widget(self.w)
end

function brightness_root:signals()
  self.slider:connect_signal('property::value', function()
    spawn.with_shell('light -S ' .. self.slider.value)
  end)
  awesome.connect_signal("daemon::brightness", function(brightness)
    if not (brightness == nil or brightness == '') then
      self.slider.value = brightness
    end
  end)
end

local brightness_widget = class(brightness_root)

function brightness_widget:init()
  brightness_root.init(self)
  return self.w
end

return brightness_widget
