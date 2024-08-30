{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.gnupg;
in
{
  options.${namespace}.services.gnupg = {
    enable = lib.mkEnableOption "gnupg";
  };

  config = lib.mkIf cfg.enable {
    # SUID wrapper, not sure if i need this, but just to not bother my future self
    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

}
