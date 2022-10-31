{
  self,
  lib,
  ...
}: {
  flake.lib = {
    kebabCaseToCamelCase =
      builtins.replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

    importDirToAttrs = dir:
      lib.pipe dir [
        lib.filesystem.listFilesRecursive
        (builtins.filter (lib.hasSuffix ".nix"))
        (map (path: {
          name = lib.pipe path [
            toString
            (lib.removePrefix "${toString dir}/")
            (lib.removeSuffix "/default.nix")
            (lib.removeSuffix ".nix")
            self.lib.kebabCaseToCamelCase
            (builtins.replaceStrings ["/"] ["-"])
          ];
          value = import path;
        }))
        builtins.listToAttrs
      ];
  };
}
