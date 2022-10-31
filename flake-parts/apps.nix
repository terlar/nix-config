{lib, ...}: {
  perSystem = {pkgs, ...}:
    lib.pipe ../apps [
      lib.filesystem.listFilesRecursive
      (map (file: pkgs.callPackage file {}))
      (map (drv: {
        apps.${drv.name} = {
          type = "app";
          program = lib.getExe drv;
        };
        checks."app-${drv.name}" = drv;
      }))
      (lib.fold lib.recursiveUpdate {})
    ];
}
