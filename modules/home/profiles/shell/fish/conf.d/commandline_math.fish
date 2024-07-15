# Commandline math
function __commandline_math_kb -e fish_user_key_bindings
    bind = __commandline_math_expand
end

function __commandline_math_expand
    set -l buffer (commandline -b)

    commandline -i '='

    if test -z "$buffer"
        commandline -a " ''"
        commandline -C 3
    end
end
