{pkgs, ...}: {
  environment.systemPackages = [pkgs.gnupg pkgs.yubikey-personalization];

  services = {
    pcscd.enable = true;
    udev = {
      enable = true;
      packages = [pkgs.yubikey-personalization];
    };
  };
}
