{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.profiles.user.terje.keyboards;
in
{
  options.profiles.user.terje.keyboards = {
    enable = mkEnableOption "Keyboards profile for terje";
  };

  config = mkIf cfg.enable {
    services.kmonad = {
      package = pkgs.kmonad;
      keyboards = {
        te = {
          enable = true;
          config = ''
            (defcfg
              input (device-file "/dev/input/by-id/usb-TrulyErgonomic.com_Truly_Ergonomic_CLEAVE_Keyboard-event-kbd")
              output (uinput-sink "KMonad Truly Ergonmic Cleave"
                                  "${pkgs.coreutils}/bin/sleep 1 && ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt")
              cmp-seq ralt
              cmp-seq-delay 5

              fallthrough true)

            (defsrc
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
              grv  1    2    3    4    5              6    7    8    9    0    -    =
              tab  q    w    e    r    t              y    u    i    o    p    [    ]
              lctl a    s    d    f    g              h    j    k    l    ;    '    \
              lsft z    x    c    v    b    del  bspc n    m    ,    .    /    rsft
              lctl lalt home pgup end  spc  lmet ret  spc  left up   rght ralt rctl
                             pgdn                               down)

            (defalias las (tap-hold-next-release 1000 spc lalt))
            (defalias ras (tap-hold-next-release 1000 spc ralt))

            (deflayer qwerty
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
              grv  1    2    3    4    5              6    7    8    9    0    -    =
              tab  q    w    e    r    t              y    u    i    o    p    [    ]
              lctl a    s    d    f    g              h    j    k    l    ;    '    \
              lsft z    x    c    v    b    del  bspc n    m    ,    .    /    rsft
              lctl lalt home pgup end  @las lmet ret  @ras left up   rght ralt rctl
                             pgdn                               down)
          '';
        };
      };
    };
  };
}
