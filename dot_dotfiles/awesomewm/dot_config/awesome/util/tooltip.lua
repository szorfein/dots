local atooltip = require("awful.tooltip")
local helpers = require("helpers")

local tooltip = {}

-- https://material.io/components/tooltips/
function tooltip.create(w)
  if not w then return end
  return atooltip {
    markup = 0,
    visible = false,
    shape = helpers.rrect(50),
    timeout = 5,
    margin_leftright = 8,
    margin_topbottom = 12,
    font = M.f.caption,
    bg = M.x.on_surface,
    fg = M.x.surface,
    objects = { w }
  }
end

return tooltip
