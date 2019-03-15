use_nix() {
    set -e

    local shell="shell.nix"
    if [[ ! -f "$shell" ]]; then
        shell="default.nix"
    fi

    if [[ ! -f "$shell" ]]; then
        fail "use nix: shell.nix or default.nix not found in the folder"
    fi

    local dir="$PWD"/.direnv
    local default="$dir/default"
    if [[ ! -L "$default" ]] || [[ ! -d `readlink "$default"` ]]; then
        local wd="$dir/env-`md5sum "$shell" | cut -c -32`" # TODO: Hash also the nixpkgs version?
        mkdir -p "$wd"

        local drv="$wd/env.drv"
        if [[ ! -f "$drv" ]]; then
            log_status "use nix: deriving new environment"
            IN_NIX_SHELL=1 nix-instantiate --add-root "$drv" --indirect "$shell" > /dev/null
            nix-store -r `nix-store --query --references "$drv"` --add-root "$wd/dep" --indirect > /dev/null
        fi

        rm -f "$default"
        ln -s `basename "$wd"` "$default"
    fi

    local drv=`readlink -f "$default/env.drv"`
    local dump="$dir/dump-`md5sum ".envrc" | cut -c -32`-`md5sum $drv | cut -c -32`"

    if [[ ! -f "$dump" ]] || [[ "$XDG_CONFIG_DIR/direnv/direnvrc" -nt "$dump" ]]; then
        log_status "use nix: updating cache"

        old=`find "$dir" -name 'dump-*'`
        nix-shell "$drv" --show-trace "$@" --run 'direnv dump' > "$dump"
        rm -f $old
    fi

    direnv_load cat "$dump"

    watch_file "$default"
    watch_file shell.nix
    if [[ $shell == "default.nix" ]]; then
        watch_file default.nix
    fi
}
