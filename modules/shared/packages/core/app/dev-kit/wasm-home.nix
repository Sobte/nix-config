{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # wasm
    binaryen
    emscripten
  ];
}
