{
  config,
  lib,
  ...
}: let
  cfg = config.profiles.gnupg;
in {
  options.profiles.gnupg = {
    enable = lib.mkEnableOption "GnuPG Profile";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      settings.keyserver = lib.mkDefault "hkps://keys.openpgp.org";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = lib.mkDefault true;
    };

    # Prevent GNOME Keyring from stealing SSH_AUTH_SOCK.
    xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=SSH Key Agent
      X-GNOME-Autostart-enabled=false
    '';
  };
}
