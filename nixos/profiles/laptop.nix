{
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware/backlight.nix];

  networking.networkmanager.enable = true;

  hardware = {bluetooth.enable = true;};

  services = {
    # Enable zero-configuration networking and service discorvery.
    avahi = {
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
    };

    # Improve touch-pad behavior.
    xserver.libinput.touchpad = {
      disableWhileTyping = true;
      tapping = false;
      tappingDragLock = false;
      middleEmulation = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
    };

    # Monitor and control temperature.
    thermald.enable = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [powertop];
}
