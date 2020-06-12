{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ ripgrep ripgrep-all ];

  home.sessionVariables.RIPGREP_CONFIG_PATH =
    "${config.xdg.configHome}/ripgrep/config";
  xdg.configFile."ripgrep/config".text = ''
    --max-columns=150
    --max-columns-preview

    --glob=!.git/*

    --smart-case
  '';
}
