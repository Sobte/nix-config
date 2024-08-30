{ lib, namespace, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) host;
in
{
  options.${namespace}.user = {
    name = mkOption {
      type = types.str;
      default = host.name;
    };
  };

  config = {
    ${namespace}.home.extraOptions = {
      programs = {
        zsh.initExtra = lib.mkAfter ''
          # ulimit
          ulimit -n 4096
        '';
      };
    };
  };
}
