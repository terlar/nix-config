{pkgs, ...}: {
  environment.systemPackages = [pkgs.gnupg pkgs.yubikey-personalization];

  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };
}
