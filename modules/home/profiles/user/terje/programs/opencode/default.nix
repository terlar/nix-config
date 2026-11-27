{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.profiles.user.terje.programs.opencode;

  skillsFrom =
    pkg: prefix: paths:
    lib.mapAttrs' (name: path: lib.nameValuePair "${prefix}${name}" "${pkg}/${path}") paths;
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
        diagram-design = "${pkgs.diagram-design}/diagram-design";
      }
      // skillsFrom pkgs.superpowers "superpowers-" (
        lib.genAttrs [
          "brainstorming"
          "dispatching-parallel-agents"
          "executing-plans"
          "finishing-a-development-branch"
          "receiving-code-review"
          "requesting-code-review"
          "subagent-driven-development"
          "systematic-debugging"
          "test-driven-development"
          "using-git-worktrees"
          "using-superpowers"
          "verification-before-completion"
          "writing-plans"
          "writing-skills"
        ] lib.id
      )
      // skillsFrom pkgs.mattpocock-skills "" {
        codebase-design = "engineering/codebase-design";
        domain-modeling = "engineering/domain-modeling";
        grill-with-docs = "engineering/grill-with-docs";
        improve-codebase-architecture = "engineering/improve-codebase-architecture";
        pr = "engineering/pr";
        prototype = "engineering/prototype";
        research = "engineering/research";
        retro = "engineering/retro";
        wizard = "engineering/wizard";
        grilling = "productivity/grilling";
        handoff = "productivity/handoff";
        teach = "productivity/teach";
        to-questionnaire = "productivity/to-questionnaire";
        writing-for-agents = "productivity/writing-for-agents";
      };

      settings = {
        autoshare = false;
        autoupdate = false;

        plugins = [
          "${pkgs.ponytail}/.opencode/plugins"
        ];

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

      cli = {
        prompt.paste = "full";
      };
    };
  };
}
