{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.cli-apps.shell.zsh;
in
{
  options.${namespace}.shared.cli-apps.shell.zsh = {
    enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf cfg.enable {
    # create /etc/zshrc that loads the environment
    programs.zsh.enable = true;
  };

}
