{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkIf;

  cfg = config.profiles.user.terje.shell;
in
{
  options.profiles.user.terje.shell = {
    enable = lib.mkEnableOption "Shell profile for Terje";
  };

  config = mkIf cfg.enable {
    profiles = {
      user.terje = {
        shell.fish = {
          enable = mkDefault true;
          enableBaseConfig = mkDefault true;
        };

        programs = {
          glow.enable = mkDefault true;
          password-store.enable = mkDefault true;
        };
      };
    };

    home = {
      packages = [
        pkgs.pdfgrep
        pkgs.unzip
      ];

      shellAbbrs = lib.mkMerge [
        {
          f = "find-src";
          gg = "ghq get";

          g = "git";
          ga = "git add";
          gan = "git add --intent-to-add";
          gap = "git add --all --patch";
          gb = "git branch";
          gc = "git commit";
          gco = "git checkout";
          gcp = "git cherry-pick";
          gd = "git diff";
          gdc = "git diff --cached";
          gdp = "git diff --patch";
          gds = "git diff --stat";
          gdt = "git difftool";
          gdw = "git diff --color-words";
          gf = "git fetch";
          gl = "git log --oneline";
          glf = "git log --patch --pretty=fuller --show-signature";
          gls = "git log --stat";
          gwc = "git log --patch";
          gm = "git merge";
          gp = "git push --force-with-lease";
          gpo = "git push --set-upstream origin";
          gr = "git rebase";
          gri = "git rebase --interactive";
          gs = "git status -sb";
          gst = "git stash";
          gsta = "git stash apply";
          gstp = "git stash show --patch";
          gsts = "git stash show --stat";

          k = "kubectl";
          kd = "kubectl describe";
          kg = "kubectl get";
          kl = "kubectl logs";

          jq = "jaq";
        }

        (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          j = "journalctl --since=today";
          je = "journalctl --since=today --priority=0..3";
          jb = "journalctl --boot";
          jf = "journalctl --follow";
          ju = "journalctl --unit";
          juu = "journalctl --user-unit";

          sc = "systemctl";
          scu = "systemctl --user";
        })
      ];
    };
  };
}
