module.exports = {
  platform: "github",
  // Commits via the API are signed by GitHub; conform requires signed commits.
  platformCommit: "enabled",
  repositories: ["terlar/nix-config"],
  requireConfig: "required",
  // Validated after templating, so depName can only be a plain attribute name.
  allowedCommands: ["^nix-update --version=(skip|branch) --flake [\\w-]+$"],
};
