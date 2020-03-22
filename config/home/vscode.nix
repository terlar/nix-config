{ pkgs, ... }:

let
  vsliveshare = builtins.fetchGit {
    url = "https://github.com/msteen/nixos-vsliveshare.git";
    ref = "refs/heads/master";
  };
in {
  imports = [
    "${vsliveshare}/modules/vsliveshare/home.nix"
  ];

  services.vsliveshare = {
    enable = true;
    extensionsDir = "$HOME/.vscode/extensions";
    nixpkgsPath = <nixpkgs> ;
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Phantom";
      "[nix]"."editor.tabSize" = 2;
      "window.zoomlevel" = 0;
      "ActiveFileInStatusBar.enable" = true;
      "ActiveFileInStatusBar.fullpath" = false;
    };
    extensions = with pkgs; [
      vscode-extensions.bbenoist.Nix
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
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
        name = "material-icon-theme";
        publisher = "pkief";
        version = "4.0.1";
        sha256 = "04zv2blnrsy87c4n4sj0yg1s90aad754b6vg02gii3jvqhl5060h";
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
    ];
  };
}
