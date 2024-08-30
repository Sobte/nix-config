{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = {
    enable = lib.mkEnableOption "openssh";
  };

  config = lib.mkIf cfg.enable {
    # enable openssh
    services.openssh.enable = true;
  };

}
