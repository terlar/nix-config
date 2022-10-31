{
  self,
  lib,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    overlays = [
      self.overlays.default
      self.overlays.gnomeExtensions
    ];
    pkgs' = pkgs.extend (lib.composeManyExtensions overlays);
  in {
    packages = {
      inherit (pkgs') project-init saw iosevka-slab;
      paperwm40 = pkgs'.gnome40Extensions.paperwm;
      paperwm42 = pkgs'.gnome42Extensions.paperwm;
    };

    legacyPackages = {
      wrapPackage = {
        wrapper,
        package,
        exes ? [(lib.getExe package)],
      }: let
        wrapperExe = lib.getExe wrapper;
        wrapExe = exe:
          pkgs.writeShellScriptBin (builtins.baseNameOf exe) ''
            exec ${wrapperExe} ${exe} "$@"
          '';
      in
        pkgs.symlinkJoin {
          name = "${package.name}-${wrapper.name}";
          paths = (map wrapExe exes) ++ [package];
        };

      wrapPackages = pkgsWrapperFn: pkgNames: final: prev: let
        wrapper = pkgsWrapperFn final;
      in
        builtins.listToAttrs (map (name: {
            inherit name;
            value = config.legacyPackages.wrapPackage {
              inherit wrapper;
              package = prev.${name};
            };
          })
          pkgNames);
    };
  };
}
