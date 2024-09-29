{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.shared.services.sing-box;
in
{
  options.${namespace}.shared.services.sing-box = {
    enable = lib.mkEnableOption "sing-box";
  };

  config = lib.mkIf cfg.enable (
    { }
    // (lib.optionalAttrs isLinux {
      # enable sing-box
      services.sing-box.enable = true;
      systemd.services.sing-box = {
        # use own config
        preStart = lib.mkForce "";
      };
    })
  );
}
