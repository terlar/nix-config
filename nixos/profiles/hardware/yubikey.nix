{pkgs, ...}: {
  environment.systemPackages = [pkgs.gnupg pkgs.yubikey-personalization];

  services = {
    pcscd.enable = true;
    udev = {
      enable = true;

      # WSL+usbip compatibility fix.
      extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0010|0110|0111|0114|0116|0401|0403|0405|0407|0410", MODE="0666"
      '';
    };
  };

  security.polkit = {
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
           subject.isInGroup("wheel") &&
           action.id == "org.debian.pcsc-lite.access_card"
        ) { return polkit.Result.YES; }
      });
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("wheel") &&
          action.id == "org.debian.pcsc-lite.access_pcsc"
        ) { return polkit.Result.YES; }
      });
    '';
  };
}
