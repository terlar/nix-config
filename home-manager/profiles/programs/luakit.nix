{ pkgs, ... }:

{
  home.packages = [ pkgs.luakit ];

  xdg.configFile."luakit/userconf.lua".text = ''
    local vertical_tabs = require "vertical_tabs"

    local settings = require "settings"
    settings.vertical_tabs.sidebar_width = 120

    local select = require "select"
    select.label_maker = function ()
      local chars = interleave("asdfg", "hjkl")
      return trim(sort(reverse(chars)))
    end
  '';
}
