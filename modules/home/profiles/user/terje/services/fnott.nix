{ lib, config, ... }:

let
  cfg = config.profiles.user.terje.services.fnott;
in
{
  options.profiles.user.terje.services.fnott = {
    enable = lib.mkEnableOption "fnott configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    services.fnott = {
      enable = true;
      settings = {
        main = {
          title-color = "a5adceff";
          summary-color = "c6d0f5ff";
          body-color = "c6d0f5ff";
          background = "303446ff";
          border-color = "8caaeeff";
          progress-bar-color = "737994ff";
        };
        low = {
          idle-timeout = 150;
          max-timeout = 30;
          default-timeout = 8;
        };
        normal = {
          idle-timeout = 150;
          max-timeout = 30;
          default-timeout = 8;
        };
        critical = {
          idle-timeout = 0;
          max-timeout = 0;
          default-timeout = 0;
          border-color = "eb4d4bff";
        };
      };
    };
  };
}
