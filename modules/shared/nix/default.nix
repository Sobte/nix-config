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
        lazy-trees = true;

        substituters = [
          "https://install.determinate.systems"
          "https://cache.garnix.io"
          "https://hyprland.cachix.org"
        ];

        trusted-public-keys = [
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    };
  };
}
