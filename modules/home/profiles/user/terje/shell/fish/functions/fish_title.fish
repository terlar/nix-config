function fish_title
    test $TERM = eterm-color && return

    set -l command (echo $_)

    if test $command = fish
        echo $__prompt_context_current
    else
        echo $command
    end
end
