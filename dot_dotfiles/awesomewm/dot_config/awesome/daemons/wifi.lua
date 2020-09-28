local timer = require("gears.timer")
local io = { lines = io.lines }
local string = { match = string.match }

local function wifi_str()
  local wifi = { interface = 'N/A', str = 0 }
  for line in io.lines("/proc/net/wireless") do
    local dev, str = string.match(line, '([%w]+):[%s]+[%d]+[%s]+([%d]+).')
    if dev then wifi.interface = dev end
    if str then wifi.str = str end
  end

  awesome.emit_signal("daemon::wifi", wifi)
end

timer {
  timeout = 20, autostart = true, call_now = true,
  callback = function() wifi_str() end
}
