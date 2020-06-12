{ ... }:

{
  gtk = {
    gtk2.extraConfig = ''
      gtk-key-theme-name = "Emacs"
    '';
    gtk3.extraConfig = { gtk-key-theme-name = "Emacs"; };
  };
}
