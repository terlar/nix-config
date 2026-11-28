{ lib, ... }:

let
  actions = {
    checkout = "actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1"; # v7
    install-nix = "cachix/install-nix-action@382a9ed9481c7c1f94f68b72ef105b3417c73877"; # v32
    cachix = "cachix/cachix-action@38b082610b782e7e93e209c35fd730d399dee866"; # v17
    free-disk-space = "jlumbroso/free-disk-space@ceedf095f4ec1a097402bc6bd80831f2e1a6fde6"; # v2.0.0
  };

  nixSetup =
    {
      skipPush ? false,
    }:
    [
      {
        name = "Install Nix";
        uses = actions.install-nix;
        "with".install_url = "https://releases.nixos.org/nix/nix-2.33.0/install";
      }
      {
        name = "Nix cache (cachix)";
        uses = actions.cachix;
        "with" = {
          useDaemon = true;
          name = "terlar";
          authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
        }
        // lib.optionalAttrs skipPush { skipPush = true; };
      }
    ];

  flakePaths = [
    "flake.nix"
    "flake.lock"
  ];
in
{
  first-ci-kit.pipelines.default = {
    github-actions = {
      defaultRunsOn = "ubuntu-latest";
      checkoutAction = actions.checkout;
      settings = {
        name = "CI";
        on.push.branches = [ "main" ];
        on.pull_request.branches = [ "main" ];
        jobs.changes.name = "Changes";
      };
    };

    jobSets.nix = {
      jobs = [
        "check"
        "pre-commit"
        "build-home-configuration"
        "build-nixos-configuration"
      ];
      jobDefaults.github-actions.steps = lib.mkOrder 550 (nixSetup { });
    };

    jobSets.nix-iso = {
      jobs = [ "build-iso" ];
      jobDefaults.github-actions.steps = lib.mkOrder 550 (nixSetup {
        skipPush = true;
      });
    };

    jobs = {
      check = {
        github-actions.name = "Check";
        commands = [ "nix flake check" ];
      };

      pre-commit = {
        github-actions.name = "Pre-commit";
        github-actions.env.GITHUB_EVENT_BEFORE = "\${{ github.event.before }}";
        commands = [ "nix run .#pre-commit-ci" ];
      };

      build-home-configuration = {
        github-actions.name = "Build home configuration";
        branches.default.changes.paths = flakePaths ++ [
          "configurations/home/**"
          "modules/home/**"
        ];
        commands = [
          "nix build --print-build-logs .#homeConfigurations.terje.activationPackage"
        ];
      };

      build-nixos-configuration = {
        github-actions.name = "Build NixOS configuration";
        branches.default.changes.paths = flakePaths ++ [
          "configurations/nixos/**"
          "modules/nixos/**"
          "modules/home/**"
        ];
        github-actions.steps = lib.mkOrder 510 [
          {
            name = "Free disk space";
            uses = actions.free-disk-space;
          }
        ];
        commands = [
          "nix build --print-build-logs .#nixosConfigurations.kong.config.system.build.toplevel"
        ];
      };

      build-iso = {
        github-actions.name = "Build ISO";
        branches.default.changes.paths = flakePaths ++ [
          "configurations/nixos/installer-yubikey/**"
          "packages/drduh-gpg-conf/**"
          "packages/drduh-yubikey-guide/**"
        ];
        env.GC_DONT_GC = "1";
        commands = [
          "nix build --print-build-logs .#nixosConfigurations.installer-yubikey.config.system.build.isoImage"
        ];
      };
    };
  };
}
