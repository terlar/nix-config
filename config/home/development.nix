{ ... }:

{
  imports = [
    ./bat.nix
    ./ripgrep.nix
  ];

  # JavaScript
  home.file.".npmrc".text = ''
    ignore-scripts=true
  '';
  home.file.".yarnrc".text = ''
    disable-self-update-check true
    ignore-scripts true
  '';

  # Python
  home.file.".ipython/profile_default/ipython_config.py".source = <dotfiles/python/.ipython/profile_default/ipython_config.py>;
}
