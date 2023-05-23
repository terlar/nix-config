{pkgs, ...}: let
  name = "Terje Larsen";
  username = "terje";
in {
  system.stateVersion = "22.11";
  networking.hostName = "chameleon";

  imports = [
    ../../profiles/common.nix
    ../../profiles/graphical.nix

    ../../profiles/appearance/high-contrast.nix
    ../../profiles/development/docker.nix
    ../../profiles/wm/gnome.nix
  ];

  # WSL
  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = true;
  };

  systemd.services.wsl-vpnkit = {
    enable = true;
    description = "wsl-vpnkit";
    after = ["network.target"];

    serviceConfig = {
      ExecStart = "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
      Restart = "always";
      KillMode = "mixed";
    };

    wantedBy = ["multi-user.target"];
  };

  environment.systemPackages = [
    pkgs.linuxPackages.usbip
  ];

  # Temporary fix for tmpfs.
  systemd.additionalUpstreamSystemUnits = ["tmp.mount"];

  # System user.
  users.users.${username} = {
    description = name;
    isNormalUser = true;
    group = "users";
    extraGroups = ["audio" "disk" "docker" "networkmanager" "video" "wheel"];
    createHome = true;
    home = "/home/${username}";
  };

  # Managed home.
  home-manager.users.${username} = import ./home-manager;

  nix.settings.trusted-users = ["root" "@wheel"];

  # Free up to 1GiB whenever there is less than 100MiB left.
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';
}
