{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # cloud
    turso-cli
    awscli2
  ];
}
