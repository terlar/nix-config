{ config, lib, pkgs, ... }:

{
  imports = [ ./common.nix ];

  system.defaults = {
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 18;
      KeyRepeat = 1;
    };

    dock = {
      autohide = true;
      launchanim = false;
      orientation = "right";
    };

    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad.Clicking = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    nonUS.remapTilde = true;
  };

  fonts = {
    fonts = import ./fonts.nix { inherit pkgs; };
    enableFontDir = true;
  };

  services = {
    activate-system.enable = true;
    skhd.enable = true;
  };

  nix.trustedUsers = [ "@admin" ];

  programs.nix-index.enable = true;
}
