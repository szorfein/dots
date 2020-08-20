local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local bicon = require("util.icon")

-- beautiful vars
local fg = beautiful.widget_scrot_fg or M.x.on_background
local icon = beautiful.widget_scrot_icon or ''

-- widget creation
local scrot_icon = bicon({ icon = icon, fg = fg })

function take_scrot(time) 
  local time = time or 0
  local title = "Screenshot is taken." -- default
  if time >= 1 then
    title = "Screenshot taken in "..time.." sec(s)..."
  end
  naughty.notify{
    text = title,
    timeout = 1
  }
  awful.spawn.with_shell("scrot -d "..time.." -q 100")
end

scrot_icon:buttons(gtable.join(
  awful.button({ }, 1, function() -- left click
    take_scrot() 
  end),
  awful.button({}, 2, function() -- middle click
    take_scrot(3)
  end),
  awful.button({}, 3, function() -- right 
    take_scrot(1)
  end)
))

return scrot_icon
