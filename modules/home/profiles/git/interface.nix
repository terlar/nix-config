{ lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.profiles.git = {
    enable = mkEnableOption "git profile";

    enableAliases = mkEnableOption "recommended git aliases" // {
      default = true;
    };

    absorb.enable = mkEnableOption "install git-absorb package";
    imerge.enable = mkEnableOption "install git-imerge package";

    github = {
      enable = mkEnableOption "GitHub profile" // {
        default = true;
      };

      reuseSshConnection = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to reuse the GitHub SSH connection.

          Make git actions significantly faster by using the <command>ssh</command> option
          ControlMaster and ControlPath.
        '';
      };
    };
  };
}
