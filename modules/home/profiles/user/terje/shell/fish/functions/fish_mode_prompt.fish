function fish_mode_prompt --description 'Displays the current mode'
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" != fish_default_key_bindings
        switch $fish_bind_mode
            case default
                set_color red
                echo -n 🅽
            case insert
                set_color green
                echo -n 🅸
            case replace-one
                set_color green
                echo -n 🆁
            case visual
                set_color magenta
                echo -n 🆅
        end
        echo -n ' '
        set_color normal
    end
end
