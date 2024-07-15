function print_duration -a duration
    if test "$duration" -gt 60000
        set total_seconds (math -s0 $duration / 1000)
        if test $total_seconds -gt 3600
            set hours (math -s0 $total_seconds / 3600)
            set remainder (math -s0 $total_seconds '%' 3600)
            set minutes (math -s0 $remainder / 60)
            set seconds (math -s0 $remainder '%' 60)
            printf '(%dh%dm%ds)' $hours $minutes $seconds
        else if test $total_seconds -gt 60
            set minutes (math -s0 $total_seconds / 60)
            set seconds (math -s0 $total_seconds '%' 60)
            printf '(%dm%ds)' $minutes $seconds
        end
    else if test "$duration" -ge 100
        printf "(%'.2fs) " (string replace -r '(\d?)(\d{3})$' '$1.$2' $duration)
    end
end
