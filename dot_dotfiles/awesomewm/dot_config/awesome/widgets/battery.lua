local wibox = require("wibox")
local beautiful = require("beautiful")
local widget = require("util.widgets")
local helpers = require("helpers")
local font = require("util.font")

-- beautiful vars
local spacing = beautiful.widget_spacing or 1

-- root
local battery_root = class()

function battery_root:init(args)
  -- options
  self.fg = args.fg or beautiful.widget_battery_fg or M.x.on_surface
  self.bg = args.bg or beautiful.widget_battery_bg or M.x.surface
  self.icon = args.icon or beautiful.widget_battery_icon or { "臘", M.x.on_surface }
  self.title = args.title or beautiful.widget_battery_title or { "BAT", M.x.on_background }
  self.mode = args.mode or 'text' -- possible values: text, progressbar, slider
  self.want_layout = args.layout or beautiful.widget_battery_layout or 'horizontal' -- possible values: horizontal , vertical
  self.bar_size = args.bar_size or 200
  self.bar_colors = args.bar_colors or beautiful.bar_color or M.x.primary
  -- base widgets
  self.wicon = font.button(self.icon[1], self.icon[2])
  self.wtitle = font.h6(self.title[1], self.title[2])
  self.wtext = font.button("")
  self.background = wibox.widget {
    bg = self.bg,
    widget = wibox.container.background
  }
  self.widget = self:make_widget()
end

function battery_root:make_widget()
  if self.mode == "progressbar" then
    return self:make_progressbar()
  else
    return self:make_text()
  end
end

function battery_root:make_text()
  local w = wibox.widget {
    {
      self.wicon, self.wtext,
      spacing = spacing,
      layout = wibox.layout.fixed[self.want_layout]
    },
    widget = self.background
  }
  awesome.connect_signal("daemon::battery", function(state, percent)
    self.wicon.markup = helpers.colorize_text(state, M.x.secondary)
    self.wtext.markup = helpers.colorize_text(percent..'%', self.fg)
  end)
  return w
end

function battery_root:make_progressbar_vert(p)
  local w = wibox.widget {
    widget.centered(
      widget.box('vertical', { self.wtitle, self.wtext }), "vertical"
    ),
    widget.centered(
      widget.box('vertical', { p, self.wicon }), "vertical"
    ),
    spacing = 15,
    layout = wibox.layout.fixed.horizontal
  }
  return w
end

function battery_root:make_progressbar()
  local p = widget.make_progressbar(_, self.bar_size, self.bar_colors)
  local wp = widget.progressbar_layout(p, self.want_layout)
  local w
  if self.want_layout == 'vertical' then
    w = self:make_progressbar_vert(wp)
  else
    w = widget.box_with_margin(self.want_layout, { self.wicon, wp }, 8)
  end
  awesome.connect_signal("daemon::battery", function(state, percent, name)
    p.value = percent
    self.wtext.markup = helpers.colorize_text(name:lower(), self.fg, M.t.medium)
  end)
  return w
end

-- herit
local battery_widget = class(battery_root)

function battery_widget:init(args)
  battery_root.init(self, args)
  return self.widget
end

return battery_widget
