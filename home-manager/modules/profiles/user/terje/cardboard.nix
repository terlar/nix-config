{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.profiles.user.terje.cardboard;
in {
  options.profiles.user.terje.cardboard = {
    enable = mkEnableOption "cardboard profile for terje";
  };

  config = mkIf cfg.enable {
    xdg.configFile."cardboard/cardboardrc".source = pkgs.writeShellScript "cardboardrc" ''
      alias cutter=${pkgs.cardboard}/bin/cutter

      mod=super

      cutter config mouse_mod $mod

      cutter bind $mod+backspace quit
      cutter bind $mod+return exec foot

      cutter bind $mod+left focus left
      cutter bind $mod+right focus right
      cutter bind $mod+up focus up
      cutter bind $mod+down focus down
      cutter bind $mod+shift+left move -10 0
      cutter bind $mod+shift+right move 10 0
      cutter bind $mod+shift+up move 0 -10
      cutter bind $mod+shift+down move 0 10
      cutter bind $mod+ctrl+left resize -10 0
      cutter bind $mod+ctrl+right resize 10 0
      cutter bind $mod+ctrl+up resize 0 -10
      cutter bind $mod+ctrl+down resize 0 10

      cutter bind $mod+h focus left
      cutter bind $mod+l focus right
      cutter bind $mod+k focus up
      cutter bind $mod+j focus down
      cutter bind $mod+shift+h move -10 0
      cutter bind $mod+shift+l move 10 0
      cutter bind $mod+shift+k move 0 -10
      cutter bind $mod+shift+j move 0 10
      cutter bind $mod+ctrl+h resize -10 0
      cutter bind $mod+ctrl+l resize 10 0
      cutter bind $mod+ctrl+k resize 0 -10
      cutter bind $mod+ctrl+j resize 0 10

      cutter bind $mod+shift+i insert_into_column
      cutter bind $mod+shift+o pop_from_column

      cutter bind $mod+r cycle_width
      cutter bind $mod+w close

      for i in $(seq 1 6); do
        cutter bind $mod+$i workspace switch $((i - 1))
        cutter bind $mod+shift+$i workspace move $((i - 1))
      done

      cutter bind $mod+shift+f toggle_floating
      cutter bind $mod+tab focus cycle

      cutter config gap 10
      cutter config focus_color 210 98 115 125
    '';
  };
}
