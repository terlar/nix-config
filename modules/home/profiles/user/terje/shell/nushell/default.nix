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

        shellAliases = {
          dc = "detect columns";
          f = "find-src";
          ga = "git add";
          gap = "git add -Ap";
          gco = "git checkout";
          gd = "git diff";
          gs = "git status -sb";
        };

        envFile.text = ''
          $env.PROMPT_INDICATOR = "〉"
          $env.PROMPT_COMMAND = {
            mut parts = [
              (pwd | str replace $env.HOME "~"),
              "\n"
            ]

            if $env.LAST_EXIT_CODE != 0 {
              $parts = $parts | append (ansi red)
            }
            $parts | str join
          }

          $env.PROMPT_COMMAND_RIGHT = {
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

          $env.TRANSIENT_PROMPT_COMMAND = "\n"
        '';

        configFile.text = ''
          $env.config.show_banner = false
          $env.config.completions.algorithm = "fuzzy"
          $env.config.render_right_prompt_on_last_line = true
          $env.config.highlight_resolved_externals = true
        '';

        extraConfig = ''
          def __complete_find-src_projects [] { ghq list | lines }
          def --env find-src [project: string@__complete_find-src_projects] { cd $'(ghq root)/($project)' }
        '';
      };
    };
  };
}
