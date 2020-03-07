{ ... }:

with builtins;

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        ${readFile ./hide-nav-bar.css}
        ${readFile ./hide-tab-bar.css}
        ${readFile ./sidebery.css}
      '';
    };
  };
}
