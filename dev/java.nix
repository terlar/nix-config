{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gradle
    maven
    javaPackages.junit_4_12
    jdk
  ];
}
