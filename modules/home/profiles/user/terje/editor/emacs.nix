{ config, lib, ... }:

let
  inherit (lib) mkIf;

  cfg = config.profiles.user.terje.editor.emacs;
in
{
  options.profiles.user.terje.editor.emacs = {
    enable = lib.mkEnableOption "Emacs editor profile for Terje";
  };

  config = mkIf cfg.enable { custom.emacsConfig.enable = true; };
}
