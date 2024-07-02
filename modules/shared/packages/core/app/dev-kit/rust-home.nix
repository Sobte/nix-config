{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # rust
      rustup
      sccache
    ];
  };
}
