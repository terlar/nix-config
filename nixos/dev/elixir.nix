{ config, pkgs, ... }:

{
  imports = [
    ./erlang.nix
  ];

  environment.systemPackages = with pkgs; [
    elixir
  ];
}
