{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.profiles.user.terje.browser.firefox;
  desktopFile = "firefox.desktop";
in
{
  options.profiles.user.terje.browser.firefox = {
    enable = mkEnableOption "Firefox browser configuration for Terje";
    defaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to configure {command}`firefox` as the default
        browser using the {env}`BROWSER` environment variable and mime default applications config.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.firefox = {
        enable = true;

        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
          extraPolicies = {
            CaptivePortal = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = true;
            FirefoxHome = {
              Pocket = false;
              Snippets = false;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
          };
        };

        profiles.default = {
          isDefault = true;

          # extensions = with config.nur.repos.rycee.firefox-addons; [
          #   linkhints
          #   noscript
          #   onetab
          #   tridactyl
          #   ublock-origin
          # ];

          settings = {
            "browser.startup.homepage" = "https://github.com/terlar";

            "permissions.default.shortcuts" = 2;

            "privacy.donottrackheader.enabled" = true;
            "privacy.donottrackheader.value" = 1;

            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };

          userChrome =
            lib.pipe
              [
                ./hide-nav-bar.css
                ./hide-tab-bar.css
                ./sidebery.css
              ]
              [
                (map builtins.readFile)
                (builtins.concatStringsSep "\n")
              ];
        };
      };
    }

    (mkIf cfg.defaultBrowser {
      home.sessionVariables.BROWSER = lib.getExe config.programs.firefox.package;
      xdg.mimeApps.defaultApplications = {
        "application/xhtml+xml" = desktopFile;
        "text/html" = desktopFile;
        "text/xml" = desktopFile;
        "x-scheme-handler/ftp" = desktopFile;
        "x-scheme-handler/http" = desktopFile;
        "x-scheme-handler/https" = desktopFile;
      };
    })
  ]);
}
