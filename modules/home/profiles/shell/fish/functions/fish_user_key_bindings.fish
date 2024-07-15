function fish_user_key_bindings
    emit fish_user_key_bindings

    bind \cg cancel
    bind \e'|' 'echo; hr; commandline -f repaint'

    # Navigation
    bind \e'<' 'prevd; echo; commandline -f repaint'
    bind \e'>' 'nextd; echo; commandline -f repaint'

    # Resume background job
    bind \ez 'fg 2>&1 >/dev/null'
end
