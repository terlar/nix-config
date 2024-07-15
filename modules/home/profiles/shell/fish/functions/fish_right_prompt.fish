function fish_right_prompt --description 'Write out the prompt'
    set last_status $status

    if test "$TRANSIENT" = 1
        return
    end

    if set -q CMD_DURATION
        set_color grey
        print_duration $CMD_DURATION
        set_color normal
    end

    if test $last_status -ne 0
        set_color $fish_color_error
        echo -n [$last_status]
        set_color normal
    end
end
