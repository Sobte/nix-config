{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.rust;
in
{
  options.${namespace}.cli-apps.dev-kit.rust = {
    enable = lib.mkEnableOption "rust";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # rust
      rustup
      sccache
    ];
  };

}
