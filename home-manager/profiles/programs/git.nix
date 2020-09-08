{ pkgs, ... }:

{
  home.packages = with pkgs;
    with gitAndTools; [
      delta
      ghq
      git-crypt
      git-imerge
      git-lfs
      hub
      tig
    ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    ignores = [ ".dir-locals.el" ".direnv/" ".envrc" ];

    aliases = {
      unstage = "reset HEAD";
      uncommit = "reset --soft HEAD^";
      unpush = "push --force-with-lease origin HEAD^:master";
      recommit = "commit --amend";
      ignore = "update-index --assume-unchanged";
      unignore = "update-index --no-assume-unchanged";
      ignored = "!git ls-files -v | grep '^[[:lower:]]'";

      tags = "tag -l";
      remotes = "remote -v";
      branches = ''
        !git for-each-ref \
        --sort=-committerdate \
        --format='%(color:blue)%(authordate:relative)\t \
        %(color:red)%(authorname)\t \
        %(color:black)%(color:bold)%(refname:short)' \
        refs/remotes \
        | column -ts'\t'
      '';

      fup =
        "!git --no-pager log --stat --since '1 day ago' --author $(git config user.email)";
      head = "!git --no-pager log --stat -1";
      recent = "!git log --stat -30";
    };

    extraConfig = {
      branch = {
        # Automatic remote tracking.
        autoSetupMerge = "always";
        # Automatically use rebase for new branches.
        autoSetupRebase = "always";
      };

      fetch = { prune = "true"; };

      pull = { rebase = "true"; };

      push = { default = "simple"; };

      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";

      diff = {
        submodule = "log";
        tool = "ediff";
      };

      difftool = { prompt = "false"; };

      rebase = {
        # Support fixup and squash commits.
        autoSquash = "true";
        # Stash dirty worktree before rebase.
        autoStash = "true";
      };

      merge = {
        ff = "only";
        log = "true";
        tool = "ediff";
        conflictStyle = "diff3";
      };

      mergetool = {
        prompt = "false";
        keepBackup = "false";
      };

      # Reuse recorded resolutions.
      rerere = {
        enabled = "true";
        autoUpdate = "true";
      };

      delta = {
        features = "side-by-side line-numbers decorations";
        syntax-theme = "ansi-light";
      };

      ghq = {
        root = "~/src";

        "git@code.orgmode.org:" = { vcs = "git"; };
        "https://git.savannah.gnu.org/git/" = { vcs = "git"; };
      };

      url = {
        "ssh://git@github.com/terlar" = {
          insteadOf = "https://github.com/terlar";
        };
      };
    };
  };

  programs.ssh.matchBlocks = {
    "github" = {
      hostname = "ssh.github.com";
      port = 443;
      serverAliveInterval = 60;
      extraOptions = {
        ControlMaster = "auto";
        ControlPersist = "yes";
      };
    };
  };
}
