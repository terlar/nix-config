{ lib, ... }:

{
  options.profiles.shell = {
    enable = lib.mkEnableOption "Shell Profile";
  };
}
