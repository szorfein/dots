local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local font = require("util.font")

local icon = beautiful.widget_hostname_icon or ""
local distrib_icon = font.button(icon, M.x.primary)

function host_show() 
  awful.spawn.easy_async([[bash -c "uname -n"]], 
  function(stdout, stderr, reason, exitcode) 
    naughty.notify{
      text = stdout,
      title = "Actual Host ",
      timeout = 5,
      hover_timeout = 5,
      width = 124,
      position = "top_left",
    }
  end
  )
end

distrib_icon:connect_signal("mouse::enter", function() host_show() end)
