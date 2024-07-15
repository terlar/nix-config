function fish_setup --description 'Setup fish variables'
    set -U fish_greeting

    # Colors
    fish_load_colors

    # Settings
    set -U fish_setup_done 1
    echo 'Initial fish setup done!'
end
