local wibox = require("wibox")
local spawn = require("awful.spawn")
local button = require("utils.button")
local font = require("utils.font")

local mpc_root = class()

function mpc_root:init(args)
  self.mode = args.mode or 'text' -- text or titlebar
  self.w = self:make_widget()
end

function mpc_root:make_widget()
  if self.mode == "titlebar" then
    return wibox.widget {
      nil,
      {
        self:prev(),
        self:toggle(),
        self:next(),
        spacing = 10,
        layout = wibox.layout.fixed.horizontal
      },
      nil,
      expand = "none",
      layout = wibox.layout.align.vertical
    }
  else
    return wibox.widget {
      self:prev(),
      self:toggle(),
      self:next(),
      spacing = dpi(4),
      layout = wibox.layout.fixed.horizontal
    }
  end
end

function mpc_root:prev()
  local cmd = function() spawn("mpc prev", false) end
  return button({
    fg_icon = M.x.primary,
    icon = self.mode == "text" and font.icon("ｅ") or font.h5("ｅ"),
    command = cmd,
    layout = "horizontal"
  })
end

function mpc_root:toggle()
  local cmd = function() spawn("mpc toggle", false) end
  return button({
    fg_icon = M.x.primary,
    icon = self.mode == "text" and font.icon("Ｘ") or font.h5("Ｘ"),
    command = cmd,
    layout = "horizontal"
  })
end

function mpc_root:next()
  local cmd = function() spawn("mpc next", false) end
  return button({
    fg_icon = M.x.primary,
    icon = self.mode == "text" and font.icon("ｄ") or font.h5("ｄ"),
    command = cmd,
    layout = "horizontal"
  })
end

local mpc_widget = class(mpc_root)

function mpc_widget:init(args)
  mpc_root.init(self, args)
  return self.w
end

return mpc_widget
