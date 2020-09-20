{ lib, pkgs, ... }:

with builtins;

{
  imports = [
    ./autorandr.nix

    ../../../../home-manager/profiles/common.nix
    ../../../../home-manager/profiles/development.nix
    ../../../../home-manager/profiles/graphical.nix

    ../../../../home-manager/profiles/appearance/high-contrast.nix
    ../../../../home-manager/profiles/keybindings/emacs.nix
    ../../../../home-manager/profiles/wm/paperwm.nix
  ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/input-sources" = {
      sources = map mkTuple [
        [ "xkb" "us+altgr-intl" ]
        [ "xkb" "se" ]
        [ "ibus" "libpinyin" ]
      ];
    };
  };

  # Custom module config:
  custom = {
    defaultBrowser = {
      enable = true;
      package = pkgs.qutebrowser;
    };

    emacsConfig = {
      enable = true;
      defaultEmailApplication = true;
      defaultPdfApplication = true;
    };
  };
}
