{
  inputs,
  system,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.cli-apps.security.agenix;
in
{
  options.${namespace}.shared.cli-apps.security.agenix = {
    enable = lib.mkEnableOption "agenix";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with inputs; [
      agenix.packages.${system}.default
    ];
  };

}
