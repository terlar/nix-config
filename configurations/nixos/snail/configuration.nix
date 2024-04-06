{ pkgs, ... }:
{
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "snail";
    wireless.enable = true;
  };

  boot = {
    kernelParams = [ "console=ttyS1,115200n8" ];

    loader.raspberryPi = {
      enable = true;
      version = 3;
      uboot.enable = true;
      firmwareConfig = ''
        start_x=1
        gpu_mem=256
      '';
    };
  };

  services.openssh.enable = true;

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi;
  };

  users.users.root.openssh.authorizedKeys.keys = [ "your public key here" ];

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };

  environment.systemPackages = [ pkgs.emacs ];
}
