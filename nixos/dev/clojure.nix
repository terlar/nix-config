{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clojure
    leiningen
  ];
}
