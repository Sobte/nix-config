{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.boot.efi;
in
{
  options.${namespace}.system.boot.efi = {
    enable = lib.mkEnableOption "boot efi";
  };

  config = lib.mkIf cfg.enable {
    # use systemd-boot as the bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = 60;

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    boot.loader.systemd-boot.editor = false;
  };

}
