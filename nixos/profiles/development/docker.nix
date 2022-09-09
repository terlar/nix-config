{pkgs, ...}: {
  # Docker support.
  virtualisation.docker = {
    enable = true;
    extraOptions = "--experimental=true";
  };

  # Docker related packages.
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    docker-slim
    kubectl
  ];
}
