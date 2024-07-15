# Commandline external editor
function __commandline_edit_kb -e fish_user_key_bindings
    bind \ei __commandline_edit
end

function __commandline_edit --description 'Input command in external editor'
    set f (mktemp /tmp/fish.cmd.XXXXXXXX)
    if test -n "$f"
        set p (commandline -C)
        commandline >$f
        eval $EDITOR $f
        commandline (more $f)
        commandline -C $p
        command rm $f
    end
end
