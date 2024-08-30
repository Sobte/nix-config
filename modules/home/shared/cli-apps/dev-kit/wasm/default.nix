{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.wasm;
in
{
  options.${namespace}.cli-apps.dev-kit.wasm = {
    enable = lib.mkEnableOption "wasm";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # wasm
      binaryen
      emscripten
    ];
  };

}
