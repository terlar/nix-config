# Commandline eval
function __commandline_eval_kb -e fish_user_key_bindings
    bind \ex __commandline_eval_token
end

function __commandline_eval_token
    # Use fish -c to be able to suppress syntax errors in eval.
    set -l token (commandline -ct)
    set -l tokens (fish -c "eval string escape -- $token" 2>/dev/null)
    set -q tokens[1]
    or return

    commandline -tr ''
    commandline -i -- "$tokens"

    # Create directory if not existing. Needs to end with trailing `/`.
    if string match -q -- '*/' "$tokens"
        test -d "$tokens"
        and return
        mkdir -p "$tokens"
        commandline -t -- "$tokens"
    end
end
