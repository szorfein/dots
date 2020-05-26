local button = require("utils.button")
local font = require("utils.font")

local settings_root = class()

function settings_root:init()
  self.w = button({
    fg_icon = M.x.secondary_variant_2,
    icon = font.icon(""),
    command = settings_toggle,
    layout = "horizontal",
    margins = dpi(4),
  })
end

local settings_widget = class(settings_root)

function settings_widget:init()
  settings_root.init(self)
  return self.w
end

return settings_widget
