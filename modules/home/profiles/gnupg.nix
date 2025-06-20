{ config, lib, ... }:

let
  inherit (lib) mkDefault mkIf;
  cfg = config.profiles.gnupg;
in
{
  options.profiles.gnupg = {
    enable = lib.mkEnableOption "GnuPG profile";
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      settings.keyserver = mkDefault "hkps://keys.openpgp.org";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = mkDefault true;
    };

    # Prevent GNOME Keyring from stealing SSH_AUTH_SOCK.
    xdg.configFile."systemd/user/gcr-ssh-agent.socket" =
      mkIf config.services.gpg-agent.enableSshSupport
        {
          source = config.lib.file.mkOutOfStoreSymlink /dev/null;
        };
  };
}
