{pkgs, ...}: let
  name = "Terje Larsen";
  username = "terje";
in {
  networking.hostName = "chameleon";
  nixpkgs.config.allowUnfree = true;

  # WSL
  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = true;
  };

  environment.systemPackages = [
    pkgs.linuxPackages.usbip
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Temporary fix for tmpfs.
  systemd.additionalUpstreamSystemUnits = ["tmp.mount"];

  # System user.
  users.users.${username} = {
    description = name;
    isNormalUser = true;
    group = "users";
    extraGroups = ["wheel"];
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

  system.stateVersion = "22.11";
}
