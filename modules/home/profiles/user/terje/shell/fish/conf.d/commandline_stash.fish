# Commandline stash/pop
function __commandline_stash_kb -e fish_user_key_bindings
    bind \es __commandline_stash
    bind \eS __commandline_pop
end

function __commandline_stash -d 'Stash current command line'
    set cmd (commandline)
    test "$cmd"
    or return
    set pos (commandline -C)

    set -U command_stash $command_stash $cmd
    set -U __command_stash_pos $__command_stash_pos $pos
    commandline ''
end

function __commandline_pop -d 'Pop last stashed command line'
    if not set -q command_stash[-1]
        return
    end

    commandline $command_stash[-1]

    if set -q __command_stash_pos[-1]
        commandline -C $__command_stash_pos[-1]
        set -e __command_stash_pos[-1]
    end

    set -e command_stash[-1]
end

function __commandline_toggle -d 'Stash current commandline if not empty, otherwise pop last stashed commandline'
    set cmd (commandline)

    if test "$cmd"
        __commandline_stash
    else
        __commandline_pop
    end
end
