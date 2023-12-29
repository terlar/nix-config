{
  config,
  lib,
  ...
}: let
  inherit (lib) types;
  cfg = config.custom.keybindings;
in {
  options.custom.keybindings = {
    enable = lib.mkEnableOption "keybinding configuration";
    mode = lib.mkOption {
      type = types.nullOr (types.enum ["emacs" "vi"]);
      default = null;
      example = "emacs";
      description = "The key binding mode to use.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.mode == "emacs") {
      programs.readline.variables = {editing-mode = "emacs";};

      dconf.settings."org/gnome/desktop/interface" = {
        gtk-key-theme = "Emacs";
      };

      gtk = {
        gtk2.extraConfig = ''
          gtk-key-theme-name = "Emacs"
        '';
        gtk3.extraConfig = {gtk-key-theme-name = "Emacs";};
      };
    })
    (lib.mkIf (cfg.mode == "vi") {
      programs.readline.variables = {editing-mode = "vi";};

      # Add GTK support, see:
      # https://vim.fandom.com/wiki/Vi_key_bindings_in_gtk
    })
  ]);
}
