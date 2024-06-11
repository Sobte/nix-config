{ pkgs, ... }:
{
  # i'd rather like to configure in vscode and use config sync,
  # since changes are mostly gui based
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    };
  };
}
