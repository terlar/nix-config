{
  imports = [./autorandr.nix];
  profiles.user.terje = {
    keyboards.enable = true;
    graphical = {
      enable = true;
      desktop = true;
    };
  };
}
