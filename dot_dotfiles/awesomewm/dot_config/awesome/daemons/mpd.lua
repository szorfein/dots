local aspawn = require("awful.spawn")
local awidget = require("awful.widget")
local naughty = require("naughty")

local function mpd_info()
  local mpd = {}
  -- you should modify the path of your musics directory
  aspawn.easy_async_with_shell("~/.config/awesome/widgets/audio.sh music_details /opt/musics",
  function(stdout)

    mpd.cover, mpd.title, mpd.artist, mpd.status, mpd.album = stdout:match('img:%[(.*)%]%s?title:%[(.*)%]%s?artist:%[(.*)%]%s?state:%[(.*)%]%s?album:%[(.*)%]')

    awesome.emit_signal("daemon::mpd", mpd)
  end)
end

mpd_info()

local mpd_script = [[
  sh -c '
    mpc idleloop player
  '
]]

aspawn.easy_async_with_shell("pgrep -fx 'mpc idleloop player' | xargs kill -9", function ()
  aspawn.with_line_callback(mpd_script, {
    stdout = function(line)
      mpd_info()
    end
  })
end)

-- emit a second signal to capture the pasted time on music
awidget.watch('sh -c "mpc"', 2, function(widget, stdout)
  local mpd = {}
  mpd.time_total = stdout:match('%/([0-9]+:[0-9]+)') or 0
  mpd.past_time = stdout:match('([0-9]+:[0-9]+)%/') or 0
  mpd.past_time_percent = stdout:match('%(([0-9]+)%%%)') or 0
  mpd.full_time = mpd.past_time .. "/"..mpd.time_total .. " ("..mpd.past_time_percent.."%)"

  awesome.emit_signal("daemon::mpd_time", mpd)
end)
