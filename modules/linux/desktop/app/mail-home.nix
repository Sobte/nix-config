{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      thunderbird # email client
    ];
  };
}
