{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.docker;
in
{
  options.${namespace}.services.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    # the program that i have to use to do any work
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    users.users.${config.${namespace}.user.name} = {
      extraGroups = [ "docker" ];
    };
  };

}
