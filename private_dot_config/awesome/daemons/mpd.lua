local spawn = require('awful.spawn')
local noti = require('utils.noti')

local function music_cover()
  local script = [[
    MUSIC_DIR=$HOME/musics
    CURR=$(mpc --format "%file%" current)
    DIR="${CURR%/*}"

    covers=$(find "$MUSIC_DIR/$DIR" -maxdepth 1 -regex '.*\.\(jpe?g\|png\)' | head -n 1)

    [ -f "$covers" ] || exit
    echo "$covers"
  ]]

  spawn.easy_async_with_shell(script, function(stdout)

    local cover = '/tmp/cover.jpg'
    if not (stdout == nil or stdout == '') then
      cover = stdout:gsub('%\n', '')
    end

    --noti.info("cover -> ".. cover)
    awesome.emit_signal("daemon::mpd_cover", cover)
  end)
end

local music_infos = function()
  spawn.easy_async_with_shell([[ mpc -f %title%@@%artist%@ current ]], function(stdout)

    local title = stdout:match('(.*)@@') or ''
    local artist = stdout:match('@@(.*)@') or ''

    title = title:gsub('%\n', '')
    artist = artist:gsub('%\n', '')

    if not (title == '' or artist == '') then
      local icon = "<span foreground='" .. M.x.primary .. "'> ♫  </span>"
      noti.info(icon .. tostring(title) .. " by " .. tostring(artist)) 
    end
    awesome.emit_signal("daemon::mpd_infos", title, artist)
  end)
end

local function update_all()
  music_infos()
  music_cover()
end

-- init once
update_all()

local mpd_event_listener = [[
  sh -c '
    mpc idleloop player
  '
]]

local kill_mpd_event_listener = [[
  if pids=$(pgrep -fx "mpc idleloop player") ; then
    for pid in $pids ; do
      kill -9 "$pid" >/dev/null
    done
  end
]]

spawn.easy_async_with_shell(kill_mpd_event_listener, function()
  spawn.with_line_callback(mpd_event_listener, {
    stdout = function(line)
      update_all()
    end
  })
end)
