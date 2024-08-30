{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.nix;
in
{
  options.${namespace}.shared.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        # enable flakes support
        experimental-features = "nix-command flakes";

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
