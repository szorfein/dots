local awful = require("awful")
local wibox = require("wibox")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local helpers = require("helpers")
local change_theme = require("widgets.button_change_theme")
local font = require("util.font")
local bicon = require("util.icon")
local tooltip = require("util.tooltip")
local menu = require("util.menu")

-- beautiful var
local wibar_pos = beautiful.wibar_position or "top"

local layout_root = class()

function layout_root:init(args)
  -- options
  self.mode = args.mode or "icons" -- possible value: icons , menu , nav
  self.icon_startscreen = { "", M.x.on_background }
  self.icon_monitor = { "", M.x.on_background }
  self.icon_lockscreen = { "", M.x.on_background }
  self.icon_menu = self:choose_icon_menu()
  -- widgets
  self.monitoring_button = bicon({ icon = self.icon_monitor[1], fg = self.icon_monitor[2]})
  self.startscreen_button = bicon({ icon = self.icon_startscreen[1],fg = self.icon_startscreen[2]})
  self.lockscreen_button = bicon({ icon = self.icon_lockscreen[1], fg = self.icon_lockscreen[2]})
  self.widget = self:make_widget()
end

function layout_root:make_widget()
  if self.mode == "menu" then
    return self:make_menu()
  elseif self.mode == "nav" then
    return self:make_nav()
  else
    return self:make_icons()
  end
end

local function fixed_position(want)
  if wibar_pos == "top" or wibar_pos == "bottom" then
    return want == 'string' and "horizontal" or wibox.layout.fixed.horizontal
  else
    return want == 'string' and "vertical" or wibox.layout.fixed.vertical
  end
end

function layout_root:choose_icon_menu()
  local icon
  local wibar_position = beautiful.wibar_position or "top"
  if wibar_position == "top" then
    icon = ""
  elseif wibar_position == "bottom" then
    icon = ""
  elseif wibar_position == "left" then
    icon = ""
  elseif wibar_position == "right" then
    icon = ""
  end
  return icon
end

function layout_root:create_popup(w)
  local wmenu = menu({ elements = {
    { self.icon_startscreen[1], "start screen", " + F1", function()
      local s = awful.screen.focused()
      s.start_screen.visible = not s.start_screen.visible
    end },
    { self.icon_monitor[1], "monitor", " + F4", function()
      local s = awful.screen.focused()
      s.monitor_bar.visible = not s.monitor_bar.visible
    end },
    { self.icon_lockscreen[1], "lock", "", function()
      lock_screen_show()
    end }
    }
  })
  local popup = awful.popup {
    widget = wmenu,
    visible = false,
    bg = M.x.surface,
    ontop = true,
    hide_on_right_click = true,
    shape = helpers.rrect(10)
  }
  popup:bind_to_widget(w)
  w:buttons(gtable.join(
    awful.button( {}, 3, function()
      popup.visible = false
    end)
  ))
end

function layout_root:create_buttons()

  self.monitoring_button:buttons(gtable.join(
    awful.button({}, 1, function()
      local curr_screen = awful.screen.focused()
      curr_screen.monitor_bar.visible = not curr_screen.monitor_bar.visible
    end)
  ))

  self.startscreen_button:buttons(gtable.join(
    awful.button({}, 1, function()
      local s = awful.screen.focused()
      s.start_screen.visible = not s.start_screen.visible
    end)
  ))

  self.lockscreen_button:buttons(gtable.join(
    awful.button({}, 1, function()
      lock_screen_show()
    end)
  ))

  local function set_tooltip(w, text)
    local tt = tooltip.create(w)
    w:connect_signal('mouse::enter', function()
      tt.text = text
    end)
  end

  set_tooltip(self.monitoring_button, 'Show/Hide monitor bar')
  set_tooltip(self.startscreen_button, 'Show/Hide start_screen')
  set_tooltip(self.lockscreen_button, 'Lock screen')
end

function layout_root:make_icons()
  self:create_buttons()
  local w = wibox.widget {
    self.lockscreen_button,
    self.monitoring_button,
    self.startscreen_button,
    layout = fixed_position(ob)
  }
  return w
end

function layout_root:make_menu()
  local w = bicon({ icon = self.icon_menu, fg = M.x.on_background })
  self:create_popup(w)
  return w
end

function layout_root:make_nav()
  local w = bicon({ icon = "", fg = M.x.on_background })
  w:buttons(gtable.join(
    awful.button({}, 1, function()
      local s = awful.screen.focused()
      s.nav_drawer.visible = not s.nav_drawer.visible 
    end)
  ))
  return w
end

-- herit
local layout_widget = class(layout_root)

function layout_widget:init(args)
  layout_root.init(self, args)
  return self.widget
end

return layout_widget
