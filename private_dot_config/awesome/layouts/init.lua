return function(s)

  -- App drawer
  require("layouts.app-drawer")(s)

  -- Settings
  require("layouts.settings")(s)

  -- logout screen
  require("layouts.logout")(s)

end
