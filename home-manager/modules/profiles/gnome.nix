{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.profiles.gnome;
  installGnomeSessionScript = pkgs.writeShellScriptBin "install-gnome-session" ''
    sudo ln -fs ${pkgs.gnome.gnome-session.sessions}/share/wayland-sessions/gnome.desktop /usr/share/wayland-sessions/gnome.desktop
    sudo ln -fs ${pkgs.gnome.gnome-session.sessions}/share/xsessions/gnome.desktop /usr/share/xsessions/gnome.desktop
  '';
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

      services.gpg-agent.pinentryFlavor = "gnome3";

      home.packages = [installGnomeSessionScript];
    }
    (mkIf cfg.disableKeyringSshAgent {
      xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
        [Desktop Entry]
        Hidden=true
      '';
    })
  ]);
}
