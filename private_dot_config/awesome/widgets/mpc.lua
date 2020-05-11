local wibox = require("wibox")
local spawn = require("awful.spawn")
local button = require("utils.button")
local font = require("utils.font")

local mpc_root = class()

function mpc_root:init()
  self.w = wibox.widget {
    self:prev(),
    self:toggle(),
    self:next(),
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
  }
end

function mpc_root:prev()
  local cmd = function() spawn("mpc prev", false) end
  return button({
    fg_icon = M.x.primary,
    icon = font.icon("ｅ"),
    command = cmd,
    layout = "horizontal"
  })
end

function mpc_root:toggle()
  local cmd = function() spawn("mpc toggle", false) end
  return button({
    fg_icon = M.x.primary,
    icon = font.icon("Ｘ"),
    command = cmd,
    layout = "horizontal"
  })
end

function mpc_root:next()
  local cmd = function() spawn("mpc next", false) end
  return button({
    fg_icon = M.x.primary,
    icon = font.icon("ｄ"),
    command = cmd,
    layout = "horizontal"
  })
end

local mpc_widget = class(mpc_root)

function mpc_widget:init()
  mpc_root.init(self)
  return self.w
end

return mpc_widget
