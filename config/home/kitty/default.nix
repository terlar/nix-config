{ ... }:

{
  home.sessionVariables.TERMINAL = "kitty";
  xdg = {
    configFile."kitty/kitty.conf".source = <dotfiles/kitty/.config/kitty/kitty.conf> ;
    configFile."kitty/diff.conf".source = <dotfiles/kitty/.config/kitty/diff.conf> ;
    configFile."kitty/colors-dark.conf".source = <dotfiles/kitty/.config/kitty/colors-dark.conf> ;
    configFile."kitty/colors-light.conf".source = <dotfiles/kitty/.config/kitty/colors-light.conf> ;
  };
}
