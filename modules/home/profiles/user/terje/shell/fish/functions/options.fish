function options --description 'Get options from arguments'
    echo $argv | sed 's|--*|\\'\n'|g' | grep -v '^$'
end
