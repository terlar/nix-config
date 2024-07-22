# Aliases
abbr @ head
abbr tf 'tail -f'
abbr l 'ls -a'
abbr l. 'ls -d .*'
abbr day "date '+%d (%A)'"
abbr week "date '+%V'"
abbr month "date '+%m (%B)'"

# Math
abbr -- '+' add
abbr -- - sub
abbr -- '*' mul
abbr -- / div

# Command defaults
abbr base64 "base64 -w0"
abbr mkdir "mkdir -p"
abbr time "time -p"

if type -fq tree
    abbr tree 'tree -a'
end

if type -fq systemctl
    abbr j 'journalctl --since=today'
    abbr je 'journalctl --since=today --priority=0..3'
    abbr jb 'journalctl --boot'
    abbr jf 'journalctl --follow'
    abbr ju 'journalctl --unit'
    abbr juu 'journalctl --user-unit'

    abbr sc systemctl
    abbr scs 'systemctl status'
    abbr scl 'systemctl list-units'

    abbr scu 'systemctl --user'
    abbr scus 'systemctl --user status'
    abbr scul 'systemctl --user list-units'
end

if type -fq git
    abbr g git
    abbr gb 'git branch'
    abbr gs 'git status -sb'
    abbr gco 'git checkout'
    abbr gf 'git fetch'

    abbr gl 'git log --oneline'
    abbr gll 'git log'
    abbr glll 'git log --stat'
    abbr gwc 'git log --patch --abbrev-commit --pretty=medium'

    abbr gd 'git diff'
    abbr gdt 'git difftool'
    abbr gdc 'git diff --cached'
    abbr gdw 'git diff --color-words'
    abbr gds 'git diff --stat'

    abbr ga 'git add'
    abbr gap 'git add -Ap'

    abbr gc 'git commit'
    abbr gca 'git commit -a'
    abbr gcm 'git commit -m'
    abbr gcp 'git cherry-pick'
    abbr gr 'git rebase'

    abbr gm 'git merge'
    abbr gpf 'git push --force-with-lease'
    abbr gpo 'git push --set-upstream origin'

    abbr gst 'git stash'
    abbr gsts 'git stash show -p'
    abbr gsta 'git stash apply'
end

if type -fq kubectl
    abbr k kubectl
    abbr kg 'kubectl get'
    abbr kd 'kubectl describe'
    abbr kl 'kubectl logs'
end

if type -fq ghq
    abbr f find-src
    abbr gg 'ghq get'
end

if type -q nix
    abbr n nix
    abbr nb 'nix build'
    abbr ndrv 'nix derivation show'
    abbr nf 'nix search nixpkgs'
    abbr nl 'nix log'
    abbr nd 'nix develop'
    abbr nr 'nix run'
    abbr ns 'nix shell'
end
