local button = require("utils.button")
local font = require("utils.font")

local launcher_root = class()

function launcher_root:init()
  self.w = button({
    fg_icon = M.x.on_primary,
    icon = font.icon(""),
    command = app_drawer_toggle,
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
