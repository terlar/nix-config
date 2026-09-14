{ config, lib, ... }:
let
  cfg = config.profiles.console;
in
{
  options.profiles.console = {
    enable = lib.mkEnableOption "Console/Virtual terminal";
  };

  config = lib.mkIf cfg.enable {
    # Virtual terminal.
    services.kmscon = {
      enable = lib.mkDefault true;
      # Make theme/font configurable in single place.
      config = {
        hwaccel = lib.mkDefault true;
        palette = "solarized-white";
        font-name = "Iosevka Curly Slab";
        font-size = 16;
      };
    };
  };
}
