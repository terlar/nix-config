# Show prompt context on directory switch
function __prompt_context_kb --on-event fish_user_key_bindings
    bind --preset \cl 'echo -n (clear | string replace \e\[3J ""); commandline -f repaint; __prompt_context'
end

function __prompt_context --on-variable PWD
    set prompt ' '
    set git_dir (command git rev-parse --show-toplevel 2>/dev/null)

    if test -n "$git_dir"
        set project (string split '/' $git_dir)[-1]
        set short_pwd (string replace $git_dir $project $PWD)

        set branch (command git symbolic-ref --short --quiet HEAD)
        set dirty (command git diff --no-ext-diff --ignore-submodules --quiet; echo $status)
        set unmerged (command git cherry -v @\{upstream\} 2>/dev/null)

        if test $dirty -ne 0
            set branch {$branch}
        else
            set branch {$branch}
        end

        if test -n "$unmerged"
            set branch $branch'⟳'
        end

        set prompt {$prompt}{$short_pwd}' on '{$branch}
    else
        set short_pwd (string replace -r "^$HOME" '~' $PWD)
        set prompt {$prompt}{$short_pwd}
    end

    if set -q TMUX
        tmux set -q status-left $prompt
    else
        echo $prompt
    end
end
