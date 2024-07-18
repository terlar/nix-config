# Commandline pipe
function __pipe_kb -e fish_user_key_bindings
    bind \epp "__commandline_insert_pipe $PAGER"
    bind \eph '__commandline_insert_pipe head'
    bind \ept '__commandline_insert_pipe tail'
    bind \epg '__commandline_insert_pipe grep'
    bind \epw '__commandline_insert_pipe wc'
end

function __commandline_insert_pipe
    commandline -i " | $argv"
end
