{pkgs, ...}: {
  # IRC gateway for message services.n
  services.bitlbee = {
    enable = true;
    plugins = [pkgs.bitlbee-facebook];
    libpurple_plugins = [pkgs.purple-hangouts pkgs.telegram-purple];
  };
}
