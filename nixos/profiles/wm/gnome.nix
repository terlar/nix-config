{
  services = {
    xserver = {
      enable = true;

      # Display manager
      displayManager.gdm.enable = true;

      # Desktop manager
      desktopManager.gnome.enable = true;
    };

    # Gnome 3 enables power-profiles-daemon which conflicts with TLP.
    tlp.enable = false;
  };
}
