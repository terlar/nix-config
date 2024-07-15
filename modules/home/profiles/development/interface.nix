{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;

  mkIndentStyleOption =
    lang: default:
    mkOption {
      type = types.enum [
        "space"
        "tab"
      ];
      inherit default;
      description = "Indentation style for ${lang}";
    };

  mkIndentSizeOption =
    lang: default:
    mkOption {
      type = types.int;
      inherit default;
      description = "Indentation size for ${lang}";
    };
in
{
  options.profiles.development = {
    enable = mkEnableOption "Development profile";

    sourceDirectory = mkOption {
      type = types.either types.path types.str;
      default = "~/src";
      apply = toString; # Prevent copies to Nix store.
      description = "The directory where source code is stored.";
    };

    git = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Git Development profile";
      };

      enableDelta = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use `delta` for diff outputs.
          See <https://github.com/dandavison/delta>.
        '';
      };

      enableGhq = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use `ghq` for remote repository management.
          See <https://github.com/x-motemen/ghq>.
        '';
      };

      gitHub = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable GitHub Development profile";
        };

        reuseSshConnection = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to reuse the GitHub SSH connection.

            Make git actions significantly faster by using the <command>ssh</command> option
            ControlMaster and ControlPath.
          '';
        };
      };
    };

    javascript = {
      enable = mkEnableOption "JavaScript Development profile";

      ignoreScripts = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Ignore scripts.

          This prevents modules to execute arbitrary scripts during installation. A
          inconvenient side-effect is that it also disables running scripts from
          package.json as well.
        '';
      };

      indentStyle = mkIndentStyleOption "JavaScript" "space";
      indentSize = mkIndentSizeOption "JavaScript" 2;
    };

    nix = {
      enable = mkEnableOption "Nix Development profile";
      retainShellInNixShell =
        (mkEnableOption "Retain your shell within nix shell via nix-your-shell")
        // {
          default = true;
        };
    };

    plantuml = {
      indentStyle = mkIndentStyleOption "PlantUML" "space";
      indentSize = mkIndentSizeOption "PlantUML" 2;
    };

    python = {
      enable = mkEnableOption "Python Development profile";
      indentStyle = mkIndentStyleOption "Python" "space";
      indentSize = mkIndentSizeOption "Python" 4;
    };

    shell = {
      enable = mkEnableOption "Shell Development profile";
      indentStyle = mkIndentStyleOption "Shell" "tab";
      indentSize = mkIndentSizeOption "Shell" 2;
    };
  };
}
