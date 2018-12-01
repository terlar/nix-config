{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    erlang_nox
    rebar3
  ];
}
