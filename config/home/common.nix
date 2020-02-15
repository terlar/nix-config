{ lib, ... }:

let
  sysconfig = (import <nixpkgs/nixos> {}).config;
in rec {
  # Configuration for nixpkgs within `home-manager` evaluation.
  nixpkgs.config = import ../nixpkgs.nix;

  home.file.".editorconfig".source = <dotfiles/editorconfig/.editorconfig> ;

  services = {
    lorri.enable = true;
  };

  programs = {
    home-manager = {
      enable = true;
      path = toString <home-manager>;
    };

    direnv = {
      enable = true;
    };

    gpg = {
      enable = true;
    };

    ssh = {
      enable = true;
      compression = true;
    };
  };

  xdg = {
    enable = true;

    # Configuration for nixpkgs outside `home-manager`, such as `nix-env`.
    configFile."nixpkgs/config.nix".source = ../nixpkgs.nix;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/mailto" = "emacsmail.desktop";
        "application/pdf" = "emacsclient.desktop";
      };
    };

    configFile."luakit/userconf.lua".text = ''
      local vertical_tabs = require "vertical_tabs"

      local settings = require "settings"
      settings.vertical_tabs.sidebar_width = 120

      local select = require "select"
      select.label_maker = function ()
        local chars = interleave("asdfg", "hjkl")
        return trim(sort(reverse(chars)))
      end
    '';
  };

  manual.html.enable = true;
}
