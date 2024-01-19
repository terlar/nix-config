# Code copied with slight modifications from @tadfisher at:
# https://github.com/tadfisher/flake/blob/master/home/modules/programs/gnome-shell.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.gnome-shell;

  extensionOpts = {config, ...}: {
    options = {
      id = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "user-theme@gnome-shell-extensions.gcampax.github.com";
        description = ''
          ID of the gnome-shell extension. If not provided, it
          will be obtained from <varname>package.uuid</varname> or
          <varname>package.extensionUuid</varname>.
        '';
      };

      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = "pkgs.gnome3.gnome-shell-extensions";
        description = ''
          Package providing a gnome-shell extension with id <varname>id</varname>.
        '';
      };
    };

    config = {id = mkDefault config.package.uuid or config.package.extensionUuid or null;};
  };

  themeOpts = {
    options = {
      name = mkOption {
        type = types.str;
        example = "Plata-Noir";
        description = ''
          Name of the gnome-shell theme.
        '';
      };
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExpression "pkgs.plata-theme";
        description = ''
          Package providing a gnome-shell theme named <varname>name</varname>.
        '';
      };
    };
  };
in {
  options.programs.gnome-shell = {
    enable = mkEnableOption "gnome-shell";

    extensions = mkOption {
      type = types.listOf (types.submodule extensionOpts);
      default = [];
      example = literalExpression ''
        [
          { package = pkgs.gnomeExtensions.dash-to-panel; }
          {
            id = "user-theme@gnome-shell-extensions.gcampax.github.com";
            package = pkgs.gnome3.gnome-shell-extensions;
          }
        ]
      '';
      description = ''
        List of gnome-shell extensions.
      '';
    };

    theme = mkOption {
      type = types.nullOr (types.submodule themeOpts);
      default = null;
      example = literalExpression ''
        {
          name = "Plata-Noir";
          package = [ pkgs.plata-theme ];
        }
      '';
      description = ''
        Theme to use for gnome-shell.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.extensions != {}) {
      dconf.settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = catAttrs "id" cfg.extensions;
      };
      home.packages = filter (p: p != null) (catAttrs "package" cfg.extensions);
    })

    (mkIf (cfg.theme != null) {
      dconf.settings."org/gnome/shell/extensions/user-theme".name =
        cfg.theme.name;
      home.packages = optional (cfg.theme.package != null) cfg.theme.package;
      programs.gnome-shell.extensions = [
        {
          id = "user-theme@gnome-shell-extensions.gcampax.github.com";
          package = pkgs.gnome3.gnome-shell-extensions;
        }
      ];
    })
  ]);
}
