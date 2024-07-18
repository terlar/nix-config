# Commandline sudo toggle
function __sudo_toggle_kb -e fish_user_key_bindings
    bind \er __commandline_sudo_toggle
end

function __commandline_sudo_toggle
    set pos (commandline -C)
    set cmd (commandline)

    if string match -q 'sudo *' $cmd
        set pos (expr $pos - 5)
        commandline (string replace 'sudo ' '' $cmd)
    else
        commandline -C 0
        commandline -i 'sudo '
        set pos (expr $pos + 5)
    end

    commandline -C $pos
end
