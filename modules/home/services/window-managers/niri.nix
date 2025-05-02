{
  config,
  lib,
  pkgs,
  ...
}:
let
  toKDL = lib.hm.generators.toKDL { };
  cfg = config.wayland.windowManager.niri;
  configFile = pkgs.writeText "niri-config.kdl" (
    lib.concatStringsSep "\n" (
      (lib.optional (cfg.settings != { }) (toKDL cfg.settings))
      ++ (lib.optional (cfg.extraConfig != "") cfg.extraConfig)
    )
  );

  # Validates the Niri configuration
  checkNiriConfig = pkgs.runCommandLocal "niri-config" { buildInputs = [ cfg.package ]; } ''
    niri validate --config ${configFile}
    cp ${configFile} $out
  '';

in
{
  meta.maintainers = [ lib.maintainers.terlar ];

  options.wayland.windowManager.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable configuration for Niri, a scrollable-tiling Wayland
        compositor.

        ::: {.note}
        This module configures Niri and adds it to your user's {env}`PATH`,
        but does not make certain system-level changes. NixOS users should
        enable the NixOS module with {option}`programs.niri.enable`, which
        makes system-level changes such as adding a desktop session entry.
        :::
      '';
    };

    package = lib.mkPackageOption pkgs "niri" {
      nullable = true;
      extraDescription = "Set this to null if you use the NixOS module to install Niri.";
    };

    portalPackage = lib.mkPackageOption pkgs "xdg-desktop-portal-gnome" {
      nullable = true;
    };

    xwayland.enable = lib.mkEnableOption "XWayland" // {
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      example = lib.literalExpression ''
        {
          input = {
            keyboard = {
              xkb.options = "ctrl:nocaps";
              repeat-delay = 500;
              repeat-rate = 33;
            };
            touchpad = {
              tap = [ ];
              natural-scroll = [ ];
            };
          };

          spawn-at-startup = "waybar";

          binds = {
            "Mod+Space".spawn = "fuzzel";
            "Super+Alt+L".spawn = "swaylock";
            "Ctrl+Alt+Delete".quit = [ ];
          };
        }
      '';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/niri/config.kdl`.

        See <https://github.com/YaLTeR/niri/wiki/Configuration:-Overview> for the full
        list of options.
      '';
    };

    spawnAtStartup = lib.mkOption {
      type =
        with lib.types;
        listOf (oneOf [
          str
          (listOf str)
        ]);
      default = [ ];
      apply = lib.unique;
      example = lib.literalExpression ''
        [
          "waybar"
          [ "fcitx5" "-d" ]
        ]
      '';
      description = "Processes to spawn at niri startup.";
    };

    windowRules = lib.mkOption {
      type = with lib.types; listOf (attrsOf anything);
      default = [ ];
      example = lib.literalExpression ''
        [
          {
            match._props = {
              app-id = "firefox$"
              title = "^Picture-in-Picture$"
            };
            open-floating = true
          }
        ]
      '';
      description = ''
        Window rules to adjust behavior for individual windows.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        input {
            keyboard {
                xkb {
                    options "ctrl:nocaps"
                }
            }
            touchpad {
                tap
                natural-scroll
            }
        }

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }
            Mod+T hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }
            Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }
            Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }
        }
      '';
      description = ''
        Extra configuration lines to add to {file}`$XDG_CONFIG_HOME/niri/config.kdl`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "wayland.windowManager.niri" pkgs lib.platforms.linux)
    ];

    home.packages = lib.mkIf (cfg.package != null) (
      [ cfg.package ] ++ lib.optional cfg.xwayland.enable pkgs.xwayland-satellite
    );

    wayland.windowManager.niri = lib.mkMerge [
      (lib.mkIf cfg.xwayland.enable {
        spawnAtStartup = [ "xwayland-satellite" ];
      })

      (lib.mkIf (cfg.spawnAtStartup != [ ]) {
        extraConfig = lib.pipe cfg.spawnAtStartup [
          (map (spawn-at-startup: toKDL { inherit spawn-at-startup; }))
          (builtins.concatStringsSep "\n")
        ];
      })

      (lib.mkIf (cfg.windowRules != [ ]) {
        extraConfig = lib.pipe cfg.windowRules [
          (map (window-rule: toKDL { inherit window-rule; }))
          (builtins.concatStringsSep "\n")
        ];
      })
    ];

    xdg.configFile."niri/config.kdl" = lib.mkIf (cfg.settings != { } || cfg.extraConfig != "") {
      source = checkNiriConfig;
    };

    xdg.portal = {
      enable = cfg.portalPackage != null;
      extraPortals = lib.mkIf (cfg.portalPackage != null) [ cfg.portalPackage ];
      configPackages = lib.mkIf (cfg.package != null) (lib.mkDefault [ cfg.package ]);
    };
  };
}
