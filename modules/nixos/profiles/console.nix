{
  config,
  lib,
  ...
}: let
  cfg = config.profiles.console;
in {
  options.profiles.console = {
    enable = lib.mkEnableOption "Console/Virtual terminal";
  };

  config = lib.mkIf cfg.enable {
    # Virtual terminal.
    services.kmscon = {
      enable = lib.mkDefault true;
      hwRender = lib.mkDefault true;
      # Make theme/font configurable in single place.
      extraConfig = ''
        palette=solarized-white
        font-name=Iosevka Slab
        font-size=16
      '';
    };
  };
}
