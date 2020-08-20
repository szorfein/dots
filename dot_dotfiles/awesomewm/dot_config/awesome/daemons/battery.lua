local helpers = require("helpers")
local beautiful = require("beautiful")
local gtimer = require("gears.timer")

local unknown_icon = beautiful.widget_battery_icon_unknown or ""
local discharging_icon = beautiful.widget_battery_icon_discharging or ""
local charging_icon = beautiful.widget_battery_icon_charging or ""
local full_icon = beautiful.widget_battery_icon_full or ""
local ac_icon = beautiful.widget_battery_icon_ac or "臘"

local function battery_info()
  local path_power="/sys/class/power_supply/"
  local bat = env.battery or "BAT0"
  local fpath = path_power..bat

  local battery_state = {
    ["Full\n"]        = { full_icon, M.x.on_background },
    ["Unknown\n"]     = { unknown_icon, M.x.error },
    ["Charged\n"]     = { charging_icon, M.x.primary },
    ["Charging\n"]    = { charging_icon, M.x.secondary },
    ["Discharging\n"] = { discharging_icon, M.x.error },
  }

  -- if battery is present
  local bat_present = helpers.ret_content(fpath.."/present")
  if bat_present ~= "1\n" then
    return awesome.emit_signal("daemon::battery", battery_state["Unknown\n"], 0)
  end

  -- state information
  local battery_status = helpers.ret_content(fpath.."/status")
  local state = battery_state[battery_status] or battery_state["Unknown\n"]

  -- charge now
  local remaining, capacity, capacity_design
  local charge_now = helpers.ret_content(fpath.."/charge_now")
  if charge_now then 
    capacity = helpers.ret_content(fpath.."/charge_full")
    remaining = charge_now
    capacity_design = helpers.ret_content(fpath.."/energy_full_design") or capacity
  else
    return awesome.emit_signal("daemon::battery", battery_state["Unknown\n"], 0)
  end

  local percent = math.min(math.floor(remaining / capacity * 100), 100)

  awesome.emit_signal("daemon::battery", state, percent)
end

-- update every 10 seconds
gtimer {
  timeout = 10, autostart = true, call_now = true,
  callback = function() battery_info() end
}
