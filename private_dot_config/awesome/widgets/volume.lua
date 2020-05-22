local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local button = require("utils.button")
local font = require("utils.font")
local slider = require("utils.slider")

local volume_root = class()

function volume_root:init()
  self.slider = slider.horiz()
  self.w = button({
    fg_icon = M.x.secondary,
    icon = font.icon(""),
    command = self.cmd,
    layout = "horizontal",
    margins = dpi(4),
  })
  self:gen_popup()
  self:signals()
end

function volume_root:gen_popup()
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

function volume_root:signals()
  self.slider:connect_signal('property::value', function()
    spawn.with_shell('~/bin/volume.sh set ' .. self.slider.value)
  end)
  awesome.connect_signal("daemon::volume", function(volume, is_muted)
    if not (volume == nil) then
      self.slider.value = volume
    else
      self.slider.value = 0
    end
  end)
end

local volume_widget = class(volume_root)

function volume_widget:init()
  volume_root.init(self)
  return self.w
end

return volume_widget
