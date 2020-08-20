-- Create a signal: daemon::brightness 
-- return value: brightness
local aspawn = require("awful.spawn")

local brightness_subscribe_script = [[
  bash -c "
    while (inotifywait -e modify /sys/class/backlight/?**/brightness -qq) ; do echo; done
  "
]]

local brightness_script = [[
  bash -c "
    light -G
  "
]]

local emit_brightness_info = function()
  aspawn.with_line_callback(brightness_script, {
    stdout = function(line)
      percentage = math.floor(tonumber(line))
      awesome.emit_signal("daemon::brightness", percentage)
    end
  })
end

-- Run once to initialize widgets
emit_brightness_info()

-- Kill old inotifywait process
aspawn.easy_async_with_shell("pgrep -x inotifywait | xargs kill -9", function()
  -- Update brightness status with each line printed
  aspawn.with_line_callback(brightness_subscribe_script, {
    stdout = function(_)
      emit_brightness_info()
    end
  })
end)
