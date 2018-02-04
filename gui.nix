{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [ xclip
      rofi
      firefox
      termite
      alacritty
      hyper
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
          noto-fonts
          noto-fonts-emoji
          fira
          fira-mono
          fira-code
          fantasque-sans-mono
          emojione
          emacs-all-the-icons-fonts
        ];
    };
}
