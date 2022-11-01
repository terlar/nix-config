{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.profiles.user.terje.programs.vscode;
in {
  options.profiles.user.terje.programs.vscode = {
    enable = mkEnableOption "Visual Studio Code config for terje";
  };

  config = mkIf cfg.enable {
    xdg.configFile."Code/User/keybindings.json".text = builtins.toJSON [
      {
        key = "ctrl+k";
        command = "deleteAllRight";
        when = "terminalFocus";
      }
      {
        key = "ctrl+o";
        command = "editor.action.insertLineAfter";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+w";
        command = "editor.action.deleteLines";
        when = "editorTextFocus && !editorHasSelection && !editorReadonly";
      }
      {
        key = "alt+w";
        command = "editor.action.clipboardCopyAction";
        when = "editorTextFocus && !editorHasSelection && !editorReadonly";
      }
      {
        key = "alt+shift+6";
        command = "editor.action.joinLines";
        when = "editorTextFocus && !editorReadonly";
      }
    ];

    programs.vscode = {
      enable = true;
      userSettings = {
        "update.channel" = "none";

        "workbench.colorTheme" = "Phantom";
        "workbench.iconTheme" = "material-icon-theme";

        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.wordWrap" = true;
        "window.zoomlevel" = 0;

        "ActiveFileInStatusBar.enable" = true;
        "ActiveFileInStatusBar.fullpath" = false;

        "[nix]"."editor.tabSize" = 2;
        "python.formatting.provider" = "black";
        "python.disableInstallationCheck" = true;
      };
      extensions = with pkgs;
      with vscode-extensions;
        [bbenoist.Nix ms-python.python]
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "activefileinstatusbar";
            publisher = "roscop";
            version = "1.0.3";
            sha256 = "0sbs3138hnpg4x226gyz94161i0sw7pdi4f2dcyxxwwbs86lwqp4";
          }
          {
            name = "editorconfig";
            publisher = "editorconfig";
            version = "0.14.4";
            sha256 = "0580dsxhw78qgds9ljvzsqqkd2ndksppk7l9s5gnrddirn6fdk5i";
          }
          {
            name = "emacs";
            publisher = "vscodeemacs";
            version = "0.1.2";
            sha256 = "033c19ng6sr82lcdmkpwrp7c93b843q1csgyvg0yw4n3k6mv6chs";
          }
          {
            name = "magit";
            publisher = "kahole";
            version = "0.2.3";
            sha256 = "sha256-T8prgIIwhHBZC+wDBD5UPP3Uk1at8MmZ1CEZJ9eYvxY=";
          }
          {
            name = "material-icon-theme";
            publisher = "pkief";
            version = "4.0.1";
            sha256 = "04zv2blnrsy87c4n4sj0yg1s90aad754b6vg02gii3jvqhl5060h";
          }
          {
            name = "nixfmt-vscode";
            publisher = "brettm12345";
            version = "0.0.1";
            sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
          }
          {
            name = "prettier-vscode";
            publisher = "esbenp";
            version = "3.20.0";
            sha256 = "09bm1h2ayx75vqwqfm43b7vq3383ph01gvs6r9zqqrzz18m5r1hi";
          }
          {
            name = "theme-karyfoundation-themes";
            publisher = "karyfoundation";
            version = "20.0.3";
            sha256 = "1yd3ixbnssm1kjv0wn109wp6szjlc27k33b2cz1l3bkndmjzf69b";
          }
          {
            name = "phantom";
            publisher = "tourervit";
            version = "1.1.1";
            sha256 = "01bj1dlqrjrd7ngygzh3p5ghkxk5wzkbd3ai7g3s3xncmhx4vpbr";
          }
          {
            name = "vscode-direnv";
            publisher = "rubymaniac";
            version = "0.0.2";
            sha256 = "1gml41bc77qlydnvk1rkaiv95rwprzqgj895kxllqy4ps8ly6nsd";
          }
          {
            name = "vscode-quick-select";
            publisher = "dbankier";
            version = "0.2.8";
            sha256 = "0yaa4rkg80xf9aihchxigkac22syjicj5im1b1fw0i0brl254b27";
          }
        ];
    };
  };
}
