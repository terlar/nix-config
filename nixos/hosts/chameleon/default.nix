let
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
    wslConf.automount.root = "/mnt";
    defaultUser = username;
    startMenuLaunchers = true;
  };

  # Temporary fix for tmpfs.
  systemd.additionalUpstreamSystemUnits = ["tmp.mount"];

  # System user.
  users.users.${username} = {
    description = name;
    isNormalUser = true;
    group = "users";
    extraGroups = ["adbusers" "audio" "disk" "docker" "networkmanager" "video" "wheel"];
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
