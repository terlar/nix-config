{
  lib,
  pkgs,
  ...
}:
lib.mkMerge [
  # Enable secrets store.
  {
    services.gnome3.gnome-keyring.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;
  }

  {
    # Permission escalation.
    security.polkit.enable = true;

    services = {
      autorandr.enable = true;
      compton.enable = true;

      xserver = {
        enable = true;
        autorun = true;

        # Start a DBus session.
        startDbusSession = true;

        desktopManager.xterm.enable = false;
        windowManager.i3.enable = true;

        displayManager = {
          defaultSession = "none+i3";
          lightdm = {
            enable = true;
            greeters.gtk.enable = true;
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      dex
      gnome3.gcr
      gnome3.gnome-keyring
      gnome3.seahorse
      libgnome-keyring
      libnotify
      networkmanagerapplet
      pavucontrol
      xfce.xfce4-notifyd
      xssproxy
    ];
  }
]
