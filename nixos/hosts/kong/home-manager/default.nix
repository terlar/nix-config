{pkgs, ...}: {
  imports = [./autorandr.nix];
  profiles.user.terje = {
    graphical.enable = true;
    gnome.paperwm.package = pkgs.gnome43Extensions.paperwm;
  };
}
