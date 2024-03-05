{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  cfg = config.services.ollama;
  ollamaPackage = cfg.package.override {
    inherit (cfg) acceleration;
  };
in {
  options = {
    services.ollama = {
      enable = lib.mkEnableOption (
        lib.mdDoc "Server for local large language models"
      );
      listenAddress = lib.mkOption {
        type = types.str;
        default = "127.0.0.1:11434";
        description = lib.mdDoc ''
          Specifies the bind address on which the ollama server HTTP interface listens.
        '';
      };
      acceleration = lib.mkOption {
        type = types.nullOr (types.enum ["rocm" "cuda"]);
        default = null;
        example = "rocm";
        description = lib.mdDoc ''
          Specifies the interface to use for hardware acceleration.

          - `rocm`: supported by modern AMD GPUs
          - `cuda`: supported by modern NVIDIA GPUs
        '';
      };
      package = lib.mkPackageOption pkgs "ollama" {};
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.ollama = {
      Unit = {
        Description = "Server for local large language models";
        After = ["network.target"];
      };

      Service = {
        ExecStart = "${lib.getExe ollamaPackage} serve";
        Environment = ["OLLAMA_HOST=${cfg.listenAddress}"];
      };

      Install = {WantedBy = ["default.target"];};
    };

    home.packages = [ollamaPackage];
  };

  meta.maintainers = with lib.maintainers; [terlar];
}
