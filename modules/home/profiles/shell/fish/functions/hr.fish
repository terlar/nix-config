function hr
    if test (count $argv) -eq 0
        set char '─'
    else
        set char $argv
    end

    printf "%.s$char" (seq $COLUMNS)
    echo
end
