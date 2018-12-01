{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    scala
    scalafmt
    sbt
  ];
}
