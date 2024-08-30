{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.kubernetes;
in
{
  options.${namespace}.cli-apps.operations.kubernetes = {
    enable = lib.mkEnableOption "kubernetes";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # k8s
      kubectl
      kubernetes-helm
      argocd # just to help with configs at work
    ];
  };

}
