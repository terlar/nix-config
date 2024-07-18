function unshift --description 'Prepend value and erase if existing'
    set -l variable $argv[1]
    set -e argv[1]

    for item in $argv
        set -l i (contains --index $item $$variable)
        and set -e $variable"[$i]"
    end

    set $variable $argv $$variable
    return 0
end
