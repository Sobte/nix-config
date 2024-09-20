{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.services.openssh;
in
{
  options.${namespace}.shared.services.openssh = {
    enable = lib.mkEnableOption "openssh";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openssh
    ];
    users.users.${config.${namespace}.user.name} = {
      openssh.authorizedKeys.keys = lib.${namespace}.host.authorizedKeys;
    };
  };

}