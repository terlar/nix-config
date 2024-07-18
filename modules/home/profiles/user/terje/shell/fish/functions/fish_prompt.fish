function fish_prompt --description 'Write out the prompt'
    if test $status -ne 0
        set_color $fish_color_error
    else
        set_color normal
        set_color grey
    end

    if set -q IN_NIX_SHELL
        echo -n 'λ '
    else
        echo -n '$ '
    end

    set_color normal
end
