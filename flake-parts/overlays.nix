{
  self,
  inputs,
  lib,
  ...
}: {
  flake.overlays =
    {
      default = import ../packages;
      fromInputs = lib.composeManyExtensions [
        inputs.emacs-config.overlays.default
        inputs.kmonad.overlays.default
        inputs.nixgl.overlays.default
        (final: prev: {
          inherit (inputs.home-manager.packages.${prev.stdenv.hostPlatform.system}) home-manager;
        })
      ];
    }
    // self.lib.importDirToAttrs ../overlays;
}
