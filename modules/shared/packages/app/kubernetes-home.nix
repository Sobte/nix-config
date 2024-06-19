{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # k8s
    kubectl
    kubernetes-helm
    argocd # just to help with configs at work
  ];
}
