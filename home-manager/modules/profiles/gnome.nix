{ config, lib, pkgs, ... }:

with lib;

let cfg = config.profiles.gnome;
in {
  options.profiles.gnome = {
    enable = mkEnableOption "GNOME Desktop profile";

    disableKeyringSshAgent = mkOption {
      default = true;
      type = types.bool;
      description = "Whether to disable SSH agent support in GNOME Keyring.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Declaratively manage gsettings.
      dconf.enable = true;
    }
    (mkIf cfg.disableKeyringSshAgent {
      xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
        [Desktop Entry]
        Hidden=true
      '';
    })
  ]);
}
