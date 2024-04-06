{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.user.terje.programs.firefox;
in
{
  options.profiles.user.terje.programs.firefox = {
    enable = lib.mkEnableOption "Firefox config for terje";
  };

  config = lib.mkIf cfg.enable {
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

        extensions = with config.nur.repos.rycee.firefox-addons; [
          linkhints
          noscript
          onetab
          tridactyl
          ublock-origin
        ];

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
  };
}
