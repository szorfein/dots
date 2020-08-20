local wibox = require("wibox")
local ascreen = require("awful.screen")
local helpers = require("helpers")
local abutton = require("awful.button")
local gtable = require("gears.table")
local widget = require("util.widgets")

local modal = {}

function modal:init(s)
  self.screen = s or ascreen.focused()
  self.height = ascreen.focused().geometry.height
  self.w = wibox({ x = 0, y = 0, visible = false, ontop = true, type = "splash", screen = self.screen })
  self.w.bg = M.x.on_surface .. M.e.dp01
  self.w.width = ascreen.focused().geometry.width
  self.w.height = self.height
  return self.w
end

function modal:add_buttons(f)
  if type(f) ~= "function" then return end
  self.w:buttons(gtable.join(
    abutton({}, 2, function() f() end), -- middle click
    abutton({}, 3, function() f() end) -- right click
  ))
end

-- place a widget at the center of the focused screen
function modal:run_center(w)
  self.w:setup {
    nil,
    {
      {
        nil,
        {
          {
            widget.centered(w, 'vertical'),
            margins = 18,
            widget = wibox.container.margin
          },
          shape = helpers.rrect(18),
          widget = wibox.container.background
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
      },
      layout = wibox.layout.fixed.vertical
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
  }
end

function modal:run_left(w)
  self.w:setup {
    nil,
    {
      {
        w,
        forced_height = self.height,
        widget = wibox.container.background
      },
      nil,
      nil,
      expand = "none",
      layout = wibox.layout.align.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.vertical
  }
end

return setmetatable({}, { __index = modal })
