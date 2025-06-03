{ lib, config, ... }:

let
  cfg = config.profiles.user.terje.keyboards;
in
{
  options.profiles.user.terje.keyboards = {
    enable = lib.mkEnableOption "Keyboards profile for Terje";
  };

  config = lib.mkIf cfg.enable {
    services.kmonad = {
      keyboards = {
        te = {
          enable = true;
          config = ''
            (defcfg
              input (device-file "/dev/input/by-id/usb-TrulyErgonomic.com_Truly_Ergonomic_CLEAVE_Keyboard-event-kbd")
              output (uinput-sink "KMonad Truly Ergonmic Cleave")
              cmp-seq ralt
              cmp-seq-delay 5

              fallthrough true)

            (defsrc
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
              grv  1    2    3    4    5              6    7    8    9    0    -    =
              tab  q    w    e    r    t              y    u    i    o    p    [    ]
              lctl a    s    d    f    g              h    j    k    l    ;    '    \
              lsft z    x    c    v    b    del  bspc n    m    ,    .    /    rsft
                   lalt home pgup end  spc  lmet ret       left up   rght ralt rctl
                             pgdn                               down)

            (defalias las (tap-hold-next-release 600 spc lalt))
            (defalias lmr (tap-hold-next-release 600 ret lmet))

            (deflayer qwerty
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
              grv  1    2    3    4    5              6    7    8    9    0    -    =
              tab  q    w    e    r    t              y    u    i    o    p    [    ]
              lctl a    s    d    f    g              h    j    k    l    ;    '    \
              lsft z    x    c    v    b    del  bspc n    m    ,    .    /    rsft
                   lalt home pgup end  @las @lmr @lmr      left up   rght ralt rctl
                             pgdn                               down)
          '';
        };
      };
    };
  };
}
