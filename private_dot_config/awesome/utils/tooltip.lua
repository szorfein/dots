local atooltip = require("awful.tooltip")
local helper = require("utils.helper")

local tooltip = {}

-- spec: https://material.io/components/tooltips/
function tooltip.create(w)
  if not w then return end
  return atooltip {
    markup = 0,
    visible = false,
    shape = helper.rrect(50),
    timeout = 4,
    margin_leftright = 5,
    margin_topbottom = 6,
    font = M.f.caption,
    bg = M.x.on_surface,
    fg = M.x.surface,
    objects = { w }
  }
end

return tooltip
