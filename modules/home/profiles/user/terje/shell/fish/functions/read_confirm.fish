function read_confirm
    set -l prompt 'Do you want to continue?'

    for pair in (options $argv)
        echo $pair | read -l option value

        switch $option
            case p prompt
                set prompt $value
        end
    end

    while true
        read -l -n 1 -p "echo '$prompt [y/n] '" confirm

        switch $confirm
            case Y y
                return 0
            case N n
                return 1
        end
    end
end
