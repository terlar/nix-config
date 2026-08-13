{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.profiles.user.terje.programs.opencode;

  ponytail = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "v4.9.0";
    hash = "sha256-8cYggVltBAlZ/Zj4pl1bOu7mQdZFXCmDGW4RSpvRA+w=";
  };

  superpowersSrc = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v6.2.0";
    hash = "sha256-F5LEk0yNWbMpan1vZSFZM76XSpsFGvA7h8q6Idrvenk=";
  };
in
{
  options.profiles.user.terje.programs.opencode = {
    enable = lib.mkEnableOption "OpenCode configuration for Terje";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;

      enableMcpIntegration = true;

      context = ./context.md;

      skills = {
        ast-grep = ./skills/ast-grep;
        flake-parts = ./skills/flake-parts;
        git-commit = ./skills/git-commit;
        ghq-lookup = ./skills/ghq-lookup;
        nix-coding = ./skills/nix-coding;
        jira-cli-operations = ./skills/jira-cli-operations;

        superpowers-brainstorming = "${superpowersSrc}/skills/brainstorming";
        superpowers-dispatching-parallel-agents = "${superpowersSrc}/skills/dispatching-parallel-agents";
        superpowers-executing-plans = "${superpowersSrc}/skills/executing-plans";
        superpowers-finishing-a-development-branch = "${superpowersSrc}/skills/finishing-a-development-branch";
        superpowers-receiving-code-review = "${superpowersSrc}/skills/receiving-code-review";
        superpowers-requesting-code-review = "${superpowersSrc}/skills/requesting-code-review";
        superpowers-subagent-driven-development = "${superpowersSrc}/skills/subagent-driven-development";
        superpowers-systematic-debugging = "${superpowersSrc}/skills/systematic-debugging";
        superpowers-test-driven-development = "${superpowersSrc}/skills/test-driven-development";
        superpowers-using-git-worktrees = "${superpowersSrc}/skills/using-git-worktrees";
        superpowers-using-superpowers = "${superpowersSrc}/skills/using-superpowers";
        superpowers-verification-before-completion = "${superpowersSrc}/skills/verification-before-completion";
        superpowers-writing-plans = "${superpowersSrc}/skills/writing-plans";
        superpowers-writing-skills = "${superpowersSrc}/skills/writing-skills";
      };

      settings = {
        autoshare = false;
        autoupdate = false;
        experimental = {
          disable_paste_summary = true;
        };
        plugin = [ "${ponytail}/.opencode/plugins/ponytail.mjs" ];
        reference = {
          nixpkgs-lib = {
            repository = "nix-community/nixpkgs.lib";
            branch = "master";
          };
        };
        share = "disabled";

        mcp.ast-grep = {
          command = [ "${pkgs.ast-grep-mcp}/bin/ast-grep-server" ];
          type = "local";
          env.AST_GREP_OUTPUT_FORMAT = "text";
        };

        lsp = {
          nixd = {
            command = [ (lib.getExe pkgs.nil) ];
            extensions = [ ".nix" ];
          };

          jsonls = {
            command = [
              (lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server")
              "--stdio"
            ];
            extensions = [
              ".json"
              ".jsonc"
            ];
          };

          yamlls = {
            command = [
              (lib.getExe pkgs.yaml-language-server)
              "--stdio"
            ];
            extensions = [
              ".yaml"
              ".yml"
            ];
          };

          gopls = {
            command = [ (lib.getExe pkgs.gopls) ];
            extensions = [
              ".go"
              ".mod"
              ".sum"
            ];
          };

          bashls = {
            command = [
              (lib.getExe pkgs.bash-language-server)
              "start"
            ];
            extensions = [
              ".sh"
              ".bash"
            ];
          };

          biome = {
            command = [
              (lib.getExe pkgs.biome)
              "lsp-proxy"
            ];
            extensions = [
              ".js"
              ".ts"
              ".jsx"
              ".tsx"
            ];
          };
        };
      };
    };
  };
}
