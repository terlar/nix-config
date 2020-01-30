{ ... }:

{
  programs.fish.enable = true;
  xdg = {
    configFile."fish/completions".source = <dotfiles/fish/.config/fish/completions> ;
    configFile."fish/conf.d".source = <dotfiles/fish/.config/fish/conf.d> ;
    configFile."fish/functions".source = <dotfiles/fish/.config/fish/functions> ;
  };
}
