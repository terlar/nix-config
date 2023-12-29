{
  imports = [./autorandr.nix];
  profiles.user.terje = {
    graphical = {
      enable = true;
      desktop = true;
    };
  };
}
