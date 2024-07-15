function insist
    set -l try 1
    set -l cmd $argv

    while true
        eval $cmd

        switch $status
            case 0
                echo "[Success after $try attempts]"
                return 0
            case 127
                echo "[Failed attempt $try]"
                echo Command not found >&2
                return 127
            case *
                echo "[Failed attempt $try]"
        end

        set -l wait (math "1.3 ^ $try")
        printf "[Waiting %0.1f seconds before next try]\n" $wait
        sleep $wait

        set try (expr $try + 1)
    end
end
