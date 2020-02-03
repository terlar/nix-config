{ pkgs, ... }:

{
  home.file.".Xmodmap".text = ''
    remove Control = Control_R
    keycode 0x69 = Return
    keycode 0x24 = Control_R
    add Control = Control_R
  '';

  systemd.user.services.xmodmap = {
    Unit = {
      Description = "xmodmap";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
      Before = [ "xcape.service" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.xorg.xmodmap}/bin/xmodmap %h/.Xmodmap";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  services = {
    xcape = {
      enable = true;
      timeout = 200;
      mapExpression = {
        Control_L = "Return";
        Control_R = "Return";
      };
    };
  };
}
