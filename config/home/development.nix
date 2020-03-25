{ ... }:

{
  imports = [
    ./ripgrep.nix
  ];

  home.file.".ipython/profile_default/ipython_config.py".source = <dotfiles/python/.ipython/profile_default/ipython_config.py> ;
}
