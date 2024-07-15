# Commandline token search backward
function __commandline_token_search_backward_kb -e fish_user_key_bindings
    bind \e',' __commandline_token_search_backward
end

function __commandline_token_search_backward
    set -l tokens (string escape (commandline -o))
    set -l token_count (count $tokens)

    if test $token_count -lt 2
        return
    end

    if test "$token_count" != "$__commandline_token_count"
        set -ge __commandline_token_index
    end

    if not set -gq __commandline_token_index
        set -g __commandline_token_index $token_count
        set -g __commandline_token_count (expr $token_count + 1)
    else
        set -g __commandline_token_index (expr $__commandline_token_index - 1)

        if test $__commandline_token_index = 0
            set -g __commandline_token_index (expr $token_count - 1)
        end
    end

    set -l buffer (commandline -b)
    commandline -r (string replace -r -- $tokens[-1]'$' '' $buffer)
    commandline -i $tokens[$__commandline_token_index]
end
