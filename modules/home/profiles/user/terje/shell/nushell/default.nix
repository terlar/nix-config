{ config, lib, ... }:

let
  inherit (lib) mkDefault mkIf;

  cfg = config.profiles.user.terje.shell.nushell;
in
{
  options.profiles.user.terje.shell.nushell = {
    enable = lib.mkEnableOption "Nu shell profile for Terje";
  };

  config = mkIf cfg.enable {
    programs = {
      carapace.enable = mkDefault true;
      nushell = {
        enable = true;

        shellAbbrs = {
          dc = "detect columns";
        };

        environmentVariables = lib.mkMerge [
          config.home.sessionVariables
          {
            PROMPT_INDICATOR = "〉";
            PROMPT_COMMAND = lib.hm.nushell.mkNushellInline ''
              {
                mut parts = [
                  (pwd | str replace $env.HOME "~"),
                  "\n"
                ]

                if $env.LAST_EXIT_CODE != 0 {
                  $parts = $parts | append (ansi red)
                }
                $parts | str join
              }
            '';
            PROMPT_COMMAND_RIGHT = lib.hm.nushell.mkNushellInline ''
              {
                mut parts = []

                let duration = $env.CMD_DURATION_MS | into int
                if $duration > 1000 {
                  $parts = $parts | append ($duration | into duration --unit ms)
                }

                if $env.LAST_EXIT_CODE != 0 {
                  $parts = $parts | append $"(ansi red)[($env.LAST_EXIT_CODE)](ansi reset)"
                }

                $parts | str join " "
              }
            '';
            TRANSIENT_PROMPT_COMMAND = "\n";
          }
        ];

        settings = {
          show_banner = false;
          completions.algorithm = "fuzzy";
          render_right_prompt_on_last_line = true;
          highlight_resolved_externals = true;

          keybindings = [
            {
              name = "undo";
              modifier = "control";
              keycode = "char_7";
              mode = [ "emacs" ];
              event = [ { edit = "undo"; } ];
            }
          ];
        };

        extraConfig = ''
          def __complete_find-src_projects [] { ghq list | lines }
          def --env find-src [project: string@__complete_find-src_projects] { cd $'(ghq root)/($project)' }
        '';
      };
    };
  };
}
