{ config, lib, ... }:

let
  inherit (lib.hm.nushell) toNushell;
  cfg = config.programs.nushell;
in
{
  options.programs.nushell = {
    shellAbbrs = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example = lib.literalExpression ''
        {
          l = "less";
          gco = "git checkout";
        }
      '';
      description = ''
        An attribute set that maps aliases (the top level attribute names
        in this option) to abbreviations. Abbreviations are expanded with
        the longer phrase after they are entered.
      '';
    };

    preferAbbrs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        If enabled, abbreviations will be preferred over aliases when
        other modules define aliases for fish.
      '';
    };
  };

  config = lib.mkIf (cfg.shellAbbrs != { }) {
    programs.nushell.extraConfig = ''
      let abbreviations = ${toNushell { } cfg.shellAbbrs}

      $env.config.keybindings = [
          {
              name: abbr_menu
              modifier: none
              keycode: enter
              mode: [emacs vi_normal vi_insert]
              event: [
                  { send: menu name: abbr_menu }
                  { send: enter }
              ]
          }
          {
              name: abbr_menu
              modifier: none
              keycode: space
              mode: [emacs vi_normal vi_insert]
              event: [
                  { send: menu name: abbr_menu }
                  { edit: insertchar value: ' '}
              ]
          }
      ]
      $env.config.menus = [
          {
              name: abbr_menu
              only_buffer_difference: false
              marker: none
              type: {
                  layout: columnar
                  columns: 1
                  col_width: 20
                  col_padding: 2
              }
              style: {
                  text: green
                  selected_text: green_reverse
                  description_text: yellow
              }
              source: { |buffer, position|
                  let match = $abbreviations | columns | where $it == $buffer
                  if ($match | is-empty) {
                      { value: $buffer }
                  } else {
                      { value: ($abbreviations | get $match.0) }
                  }
              }
          }
      ]
    '';
  };
}
