local spawn = require("awful.spawn")
local button = require("utils.button")
local font = require("utils.font")

local launcher_root = class()

function launcher_root:init()
  self.cmd = function()
    spawn("rofi -no-lazy-grab -show drun")
  end
  self.w = button({
    fg_icon = M.x.on_primary,
    icon = font.icon(""),
    command = self.cmd,
    layout = "horizontal",
    rrect = 5,
    margins = dpi(2),
    mode = "contained"
  })
end

local launcher_widget = class(launcher_root)

function launcher_widget:init()
  launcher_root.init(self)
  return self.w
end

return launcher_widget
