{ config, lib, pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
  };

  environment.systemPackages = with pkgs;
    [ rofi
      xclip
      maim
      firefox
      qutebrowser
      termite
      alacritty
      hyper
      dropbox-cli
      arc-theme
      arc-icon-theme
      paper-gtk-theme
      paper-icon-theme
    ];

  # Enable the X11 windowing system.
  services.xserver =
    { enable = true;
      autorun = true;

      videoDrivers = [ "intel" ];

      # Keyboard
      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "lv3:ralt_switch,ctrl:nocaps";

      # Enable touchpad support.
      libinput =
        { enable = true;
        naturalScrolling = true;
        disableWhileTyping = true;
      };

      # Enable desktop environment.
      displayManager.lightdm.enable = true;
      windowManager.i3 =
        { enable = true;
          package = pkgs.i3-gaps;
        };

      monitorSection =
        ''
        DisplaySize 508 284
        '';
    };

  # Setup fonts
  fonts =
    { enableFontDir = true;
      fonts = with pkgs;
        [ unifont
          symbola
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          fira
          fira-mono
          fira-code
          fantasque-sans-mono
          emojione
          emacs-all-the-icons-fonts
          source-han-sans-simplified-chinese
          source-han-sans-traditional-chinese
        ];
    };
}
