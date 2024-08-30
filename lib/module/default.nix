{ lib }:
let
  inherit (lib) mkDefault;
in
{
  mkDefaultEnabled = {
    enable = mkDefault true;
  };

  mkDefaultDisabled = {
    enable = mkDefault false;
  };
}
