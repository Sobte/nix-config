{
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.nix;
in
{
  options.${namespace}.nix = {
    enable = lib.mkEnableOption "nix" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        substituters = [
          "https://hyprland.cachix.org"
          "https://cache.garnix.io"
        ];

        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };
  };
}
