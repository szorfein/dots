return function(s)
  if M.name == "machine" then
    require("layouts.monitor_bar.vertical")(s)
  elseif M.name == "morpho" then
    require("layouts.monitor_bar.horizontal")(s)
  elseif M.name == "worker" then
    require("layouts.monitor_bar.horizontal_v2")(s)
  elseif M.name == "beta" then
    require("layouts.monitor_bar.horizontal_v2")(s)
    s.monitor_bar.visible = false
  else
    require("layouts.monitor_bar.horizontal")(s)
    s.monitor_bar.visible = false
  end
end 
