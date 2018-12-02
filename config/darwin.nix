{ config, lib, pkgs, ... }:

let
  home_directory = builtins.getEnv "HOME";
  nix_directory = "${home_directory}/src/github.com/terlar/nix-config";
in {
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

  services = {
    activate-system.enable = true;
    skhd.enable = true;
  };

  nix.trustedUsers = [ "@admin" ];

  programs.nix-index.enable = true;
}
