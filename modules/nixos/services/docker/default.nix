{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.docker;
in
{
  options.${namespace}.services.docker = with types; {
    enable = lib.mkEnableOption "docker";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    # the program that i have to use to do any work
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    } // cfg.extraOptions;

    users.users.${config.${namespace}.user.name} = {
      extraGroups = [ "docker" ];
    };
  };

}
