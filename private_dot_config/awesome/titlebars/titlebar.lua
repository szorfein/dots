local awful = require("awful")
local wibox = require("wibox")
local table = require("gears.table")
local font = require("utils.font")
local tooltip = require("utils.tooltip")
local button = require("utils.button")

local window_close = function(c)
  c:kill()
end

local window_maximize = function(c)
  c.maximized = not c.maximized
  c:raise()
end

local window_floating = function(c)
  c.floating = not c.floating
end


local window_sticky = function(c)
  c.sticky = not c.sticky
end

local gen_button = function(c, icon, color, cmd)
  local exec_cmd = function() cmd(c) end
  return button({ 
    fg_icon = color,
    icon = font.icon(icon),
    command = exec_cmd,
    layout = "horizontal",
    margins = dpi(1),
  })
end

client.connect_signal("request::titlebars", function(c)

-- buttons for the titlebar
  local buttons = table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c) : setup {
    { -- Left
      gen_button(c, "", M.x.secondary, window_sticky),
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      --{ -- Title
      --  align  = "center",
        --widget = awful.titlebar.widget.titlewidget(c)
      --  widget = nil,
      --},
      nil,
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      --awful.titlebar.widget.maximizedbutton(c),
      --awful.titlebar.widget.ontopbutton    (c),
      gen_button(c, "", M.x.secondary_variant_2, window_floating),
      gen_button(c, "", M.x.secondary, window_maximize),
      gen_button(c, "", M.x.secondary_variant_1, window_close),
      spacing = dpi(5),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)
