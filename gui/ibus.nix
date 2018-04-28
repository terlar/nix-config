{ config, pkgs, ... }:

{
  imports = [
    ./xserver.nix
  ];

  programs.ibus.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
  };
}
