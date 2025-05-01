{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.user.terje.base;
in
{
  options.profiles.user.terje.base = {
    enable = lib.mkEnableOption "Base profile for terje";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = lib.mkDefault "Europe/Stockholm";

    # Enable super user handling.
    security.sudo.enable = lib.mkDefault true;
    # security.doas.enable = true;

    programs.fish.enable = lib.mkDefault true;
    users.defaultUserShell = lib.mkOverride 999 pkgs.fish;
    environment = {
      sessionVariables = {
        PAGER = lib.mkDefault "less";
      };
      wordlist.enable = true;
    };

    custom = {
      keyboard = {
        enable = lib.mkDefault true;
        xkbOptions = lib.mkDefault "ctrl:nocaps";
        xkbRepeatDelay = lib.mkDefault 500;
        xkbRepeatInterval = lib.mkDefault 33; # 30Hz
      };

      i18n = {
        enable = lib.mkDefault true;
        languages = lib.mkDefault [ "chinese" ];
      };
    };

    nix = {
      package = pkgs.lix;

      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      gc = {
        automatic = true;
        dates = "12:12";
      };
    };

    services = {
      # Limit storage space of journald.
      journald.extraConfig = ''
        SystemMaxUse=100M
        RuntimeMaxUse=100M
      '';
    };

    programs = {
      command-not-found.enable = lib.mkDefault false;
      nix-index-database.comma.enable = lib.mkDefault true;
    };
  };
}
