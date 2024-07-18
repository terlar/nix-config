{ lib, ... }:

{
  options.profiles.shell = {
    enable = lib.mkEnableOption "shell profile";
  };
}
