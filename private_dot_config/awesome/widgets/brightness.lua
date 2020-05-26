local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local button = require("utils.button")
local font = require("utils.font")
local slider = require("utils.slider")

local brightness_root = class()

function brightness_root:init(args)
  self.mode = args.mode or "popup"
  self.slider = slider.horiz()
  self:make_widget()
  self:signals()
end

function brightness_root:make_widget()
  if self.mode == "slider" then
    self:init_slider()
  else
    self:init_popup()
  end
end

function brightness_root:init_slider()
  self.w = wibox.widget {
    {
      font.icon(""),
      fg = M.x.secondary,
      widget = wibox.container.background
    },
    {
      self.slider,
      margins = dpi(6),
      widget = wibox.container.margin
    },
    layout = wibox.layout.fixed.horizontal
  }
end

function brightness_root:init_popup()
  self.w = button({
    fg_icon = M.x.secondary,
    icon = font.icon(""),
    command = self.cmd,
    layout = "horizontal",
    margins = dpi(4),
  })
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

function brightness_widget:init(args)
  brightness_root.init(self, args)
  return self.w
end

return brightness_widget
