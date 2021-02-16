{ config, lib, pkgs, ... }:

with lib;
with builtins;
let cfg = config.profiles.user.terje.programs.firefox;
in
{
  options.profiles.user.terje.programs.firefox = {
    enable = mkEnableOption "Firefox config for terje";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.default = {
        isDefault = true;

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        userChrome = ''
          ${readFile ./hide-nav-bar.css}
          ${readFile ./hide-tab-bar.css}
          ${readFile ./sidebery.css}
        '';
      };
    };
  };
}
