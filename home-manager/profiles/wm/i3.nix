{ dotfiles, pkgs, ... }:

{
  imports = [ ./i3-sway.nix ../programs/rofi.nix ];

  services = {
    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --clock --color=d5d2c8";
      inactiveInterval = 10;
    };

    pasystray.enable = true;
  };

  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };

  gtk.enable = true;

  xdg.configFile."i3status/config".source =
    "${dotfiles}/i3/.config/i3status/config";
}
