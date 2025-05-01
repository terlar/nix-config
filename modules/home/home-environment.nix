{ config, lib, ... }:

let
  cfg = config.home;
in
{
  options.home.shellAbbrs = lib.mkOption {
    type = with lib.types; attrsOf str;
    default = { };
    example = lib.literalExpression ''
      {
        g = "git";
        "..." = "cd ../..";
      }
    '';
    description = ''
      An attribute set that maps abbreviations (the top level attribute names
      in this option) to command strings or directly to build outputs.

      This option should only be used to manage simple abbreviations that are
      compatible across all shells. If you need to use a shell specific
      feature then make sure to use a shell specific option, for example
      [](#opt-programs.fish.shellAbbrs) for Fish.
    '';
  };

  config = {
    programs.fish.shellAbbrs = cfg.shellAbbrs;
    programs.nushell.shellAbbrs = cfg.shellAbbrs;
  };
}
