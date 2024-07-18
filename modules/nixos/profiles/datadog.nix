{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.profiles.datadog;
in
{
  options.profiles.datadog = {
    enable = mkEnableOption "DataDog";
  };

  config = mkIf cfg.enable {
    users = {
      groups.datadog = { };
      extraUsers.datadog = {
        isSystemUser = true;
        group = "datadog";
        extraGroups = [
          "docker"
          "systemd-journal"
        ];
      };
    };

    services.datadog-agent = {
      enable = mkDefault true;
      enableLiveProcessCollection = mkDefault true;
      enableTraceAgent = mkDefault true;

      extraConfig = {
        logs_enabled = mkDefault true;
        listeners = [ { name = "docker"; } ];
        config_providers = [
          {
            name = "docker";
            polling = true;
          }
        ];
      };

      checks = {
        journald = {
          logs = [
            {
              type = "journald";
              include_units = [ "docker.service" ];
            }
          ];
        };
      };

      diskCheck = {
        init_config = { };
        instances = [
          {
            use_mount = "yes";
            exclude_filesystems = [
              "tmpfs"
              "none"
              "shm"
              "nsfs"
              "tracefs"
            ];
          }
        ];
      };
    };
  };
}
