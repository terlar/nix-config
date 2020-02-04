{ ... }:

{
  programs.autorandr = {
    enable = true;
    profiles = {
      beetle-solo = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
        };
        config = {
          DP-1.enable = false;
          eDP-1 = {
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
            dpi = 82;
          };
        };
      };

      beetle-home = {
        fingerprint = {
          DP-1 = "00ffffffffffff0006102792ec18341534150104b53c2278226fb1a7554c9e250c505400000001010101010101010101010101010101565e00a0a0a029503020350055502100001a1a1d008051d01c204080350055502100001c000000ff00433032475835484e444a47520a000000fc005468756e646572626f6c740a2001b602030cc12309070783010000565e00a0a0a029503020350055502100001a1a1d008051d01c204080350055502100001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013";
          eDP-1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
        };
        config = {
          DP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "2560x1440";
            rate = "59.95";
          };
          eDP-1 = {
            position = "0x1440";
            mode = "1920x1080";
            rate = "60.00";
            dpi = 82;
          };
        };
      };

      beetle-work-ida-DP = {
        fingerprint = {
          DP-1 = "00ffffffffffff0010acdfa04c414131301c010380502178ea0950a9554e9c26105054a54b00714f81008180a940d1c0010101010101e77c70a0d0a0295030203a00204f3100001a000000ff0036363058383842513141414c0a000000fc0044454c4c205533343137570a20000000fd0030551e5920000a20202020202001f7020322f14d9005040302071601141f12135a2309070767030c0010003844830100009d6770a0d0a0225050205a04204f3100001a9f3d70a0d0a0155050208a00204f3100001a584d00b8a1381440942cb500204f3100001e3c41b8a060a029505020ca04204f3100001a565e00a0a0a0295030203500204f3100001a0000002b";
          eDP-1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
        };
        config = {
          DP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3440x1440";
            rate = "59.97";
          };
          eDP-1 = {
            position = "0x1440";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };

      beetle-work-mob-DP = {
        fingerprint = {
          DP-1 = "00ffffffffffff004c2d080e00000e000e1b0103806639782a23ada4544d99260f474abdef80714f81c0810081809500a9c0b300010104740030f2705a80b0588a00baa84200001e000000fd00184b0f511e000a202020202020000000fc0053796e634d61737465720a2020000000ff004831414b3530303030300a20200102020340f0535f101f041305142021225d5e626364071603122309070783010000e2000fe30503016e030c001000b83c20008001020304e3060d01e50e60616566011d80d0721c1620102c2580501d7400009e662156aa51001e30468f3300501d7400001e023a801871382d40582c4500baa84200001e000000000000000000d1";
          eDP-1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
        };
        config = {
          DP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "60.00";
            scale = {
              method = "pixel";
              x = 2560;
              y = 1440;
            };
          };
          eDP-1 = {
            position = "0x1440";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };

      beetle-work-mob-HDMI = {
        fingerprint = {
          HDMI-1 = "00ffffffffffff004c2d080e00000e000e1b0103806639782a23ada4544d99260f474abdef80714f81c0810081809500a9c0b300010104740030f2705a80b0588a00baa84200001e000000fd00184b0f511e000a202020202020000000fc0053796e634d61737465720a2020000000ff004831414b3530303030300a20200102020340f0535f101f041305142021225d5e626364071603122309070783010000e2000fe30503016e030c001000b83c20008001020304e3060d01e50e60616566011d80d0721c1620102c2580501d7400009e662156aa51001e30468f3300501d7400001e023a801871382d40582c4500baa84200001e000000000000000000d1";
          eDP-1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
        };
        config = {
          HDMI-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "30.00";
            scale = {
              method = "pixel";
              x = 2560;
              y = 1440;
            };
          };
          eDP-1 = {
            position = "0x1440";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };

      beetle-work-seat1 = {
        fingerprint = {
          DP-1 = "00ffffffffffff0010acdfa04c454830121c010380502178ea0950a9554e9c26105054a54b00714f81008180a940d1c0010101010101e77c70a0d0a0295030203a00204f3100001a000000ff0036363058383835353048454c0a000000fc0044454c4c205533343137570a20000000fd0030551e5920000a202020202020012a020322f14d9005040302071601141f12135a2309070767030c0010003844830100009d6770a0d0a0225050205a04204f3100001a9f3d70a0d0a0155050208a00204f3100001a584d00b8a1381440942cb500204f3100001e3c41b8a060a029505020ca04204f3100001a565e00a0a0a0295030203500204f3100001a0000002b";
          eDP-1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
        };
        config = {
          DP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3440x1440";
            rate = "59.97";
          };
          eDP-1 = {
            position = "0x1440";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };

      kong-solo = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff004d10761400000000311a0104a52313780e5441a75435bb250c4b57000000010101010101010101010101010101014dd000a0f0703e80302035005ac210000018000000000000000000000000000000000000000000fe005932584e44804c513135364431000000000002410328001200000b010a202000f0";
        };
        config = {
          DP-1-1.enable = false;
          eDP-1-1 = {
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "60.00";
            dpi = 144;
          };
        };
      };

      kong-home = {
        fingerprint = {
          DP-1-1 = "00ffffffffffff0006102792ec18341534150104b53c2278226fb1a7554c9e250c505400000001010101010101010101010101010101565e00a0a0a029503020350055502100001a1a1d008051d01c204080350055502100001c000000ff00433032475835484e444a47520a000000fc005468756e646572626f6c740a2001b602030cc12309070783010000565e00a0a0a029503020350055502100001a1a1d008051d01c204080350055502100001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013";
          eDP-1-1 = "00ffffffffffff004d10761400000000311a0104a52313780e5441a75435bb250c4b57000000010101010101010101010101010101014dd000a0f0703e80302035005ac210000018000000000000000000000000000000000000000000fe005932584e44804c513135364431000000000002410328001200000b010a202000f0";
        };
        config = {
          DP-1-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "2560x1440";
            rate = "59.95";
          };
          eDP-1-1 = {
            position = "0x1440";
            mode = "3840x2160";
            rate = "60.00";
            dpi = 144;
          };
        };
      };
    };
  };
}