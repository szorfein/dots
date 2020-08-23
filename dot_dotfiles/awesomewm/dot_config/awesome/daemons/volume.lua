-- Create a signal: daemon::volume
-- return values: volume [number], is_muted [0 or 1]
local aspawn = require("awful.spawn")
local awidget = require("awful.widget")
local noti = require("util.noti")

if sound_system == "alsa" then
  local gtimer = require("gears.timer")

  local update_volume = function()
    aspawn.easy_async_with_shell(
      [[
      amixer -D ]]..sound_card.. [[ sget Master | grep "\[" | head -n1
      ]],
      function(stdout)
        local noti = require("util.noti")
        local volume = tonumber(stdout:match('(%d+)%%'))

        if not volume then
          noti.warn("Can't find volume on: "..sound_card)
        end
        local is_muted = volume == 0 and 1 or 0
        awesome.emit_signal("daemon::volume", volume, is_muted)
      end
    )
  end

  gtimer.start_new(5, function()
    update_volume()
    return true
  end)

else -- asume you use pulseaudio

  local function emit_volume_info()
    aspawn.easy_async("pacmd list-sinks", function(stdout)
      local volume = stdout:match('(%d+)%%') or nil
      local is_muted = stdout:match('muted:%s+yes') and true or false
      --local index_card = stdout:match('*%s+index:%s+(%d+)') or nil

      if volume ~= nil then
        awesome.emit_signal("daemon::volume", tonumber(volume), is_muted)
      else
        naughty.notify({ title = "Warning!", text = "Can't find volume: "..volume })
      end
    end
    )
  end

  -- initialize signal
  emit_volume_info()

  local volume_script = [[
    bash -c '
    pactl subscribe | grep --line-buffered "sink"
    '
  ]]

  -- update the signal when receive new things
  aspawn.easy_async_with_shell("pgrep -x pactl | xargs kill", function()

    -- Run emit_volume_info() with each line printed
    aspawn.with_line_callback(volume_script, {
      stdout = function(line)
        emit_volume_info()
      end
    })

  end)
end
