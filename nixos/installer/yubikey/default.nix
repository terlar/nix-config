{ pkgs, ... }:

{
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-curses
    paperkey
    wget
  ];

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
