{ config, pkgs, ... }:

{
  imports = [ ./xserver.nix ];

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
    ];
  };
}
