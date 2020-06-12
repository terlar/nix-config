{ pkgs, ... }:

{
  home.file.".npmrc".text = ''
    ignore-scripts=true
  '';
  home.file.".yarnrc".text = ''
    disable-self-update-check true
    ignore-scripts true
  '';

  home.packages = with pkgs; [ nodePackages.jsonlint nodePackages.prettier ];
}
