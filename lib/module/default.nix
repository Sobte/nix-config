{ lib }:
let
  inherit (lib) types mkDefault mkOption;
in
with types;
{
  mkDefaultEnabled = {
    enable = mkDefault true;
  };

  mkDefaultDisabled = {
    enable = mkDefault false;
  };

  mkMappingOption =
    {
      source,
      target,
      description ? "",
      type ? str,
    }:
    {
      source = mkOption {
        default = source;
        inherit type description;
      };
      target = mkOption {
        default = target;
        readOnly = true;
        inherit type description;
      };
    };
}
