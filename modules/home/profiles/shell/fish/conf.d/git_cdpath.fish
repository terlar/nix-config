# Automatically set CDPATH for git repositories.
function __git_cdpath --on-variable PWD
    set --local git_root (git rev-parse --show-toplevel 2>/dev/null)

    if test "$git_root" != "$__git_cdpath_current_root"
        set --local index (contains --index -- "$__git_cdpath_current_root" $CDPATH)
        set --erase __git_cdpath_current_root
        set --query index[1] && set --erase CDPATH[$index]
    end

    if not contains -- "$git_root" $CDPATH
        set --global __git_cdpath_current_root $git_root
        set --global --export CDPATH $CDPATH $git_root
    end
end
