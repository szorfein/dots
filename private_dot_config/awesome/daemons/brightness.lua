local spawn = require("awful.spawn")
local noti = require("utils.noti")

-- Subscribe to backlight changes
-- Requires inotify-tools
local brightness_subscribe_script = [[
  sh -c "
    while (inotifywait -e modify /sys/class/backlight/?**/brightness -qq) do :; done
  "
]]

local brightness_script = [[
  sh -c "
    light -G
  "
]]

local val = 0
local emit_brightness_info = function()
  spawn.with_line_callback(brightness_script, {
    stdout = function(line)
      percentage = math.floor(tonumber(line))
      if val ~= percentage then
        val = percentage
        local icon = "<span foreground='" .. M.x.primary .. "'>  </span>"
        noti.info(icon .. tostring(percentage) .. "%")
        awesome.emit_signal("daemon::brightness", percentage)
      end
    end
  })
end

-- Run once to initialize widgets
emit_brightness_info()

-- Kill old inotifywait process
spawn.easy_async_with_shell("pgrep -x inotifywait | xargs kill", function()
  -- Update brightness status with each line printed
  spawn.with_line_callback(brightness_subscribe_script, {
    stdout = function(value)
      emit_brightness_info()
    end
  })
end)
