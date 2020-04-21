{ pkgs, ... }:

{
  # Docker support.
  virtualisation.docker = {
    enable = true;
    extraOptions = "--experimental=true";
  };

  environment.systemPackages = with pkgs; [
    arion
    kubectl
  ];
}
