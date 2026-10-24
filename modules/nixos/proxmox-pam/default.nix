{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # Authen::PAM inside the Proxmox packages links against the linux-pam from
  # nixpkgs-stable (proxmox-nixos is configured to follow it). The base system
  # may be on a newer nixpkgs/glibc; PAM modules built for the newer glibc
  # cannot be loaded by the older daemon ("GLIBC_2.43 not found"), which breaks
  # both the API login (401) and the node shell ("Module is unknown").
  pam = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linux-pam;
in
{
  config = lib.mkIf (config.services.proxmox-ve.enable or false) {
    # Generate /etc/pam.d/* with the PAM from the nixpkgs used to build the
    # Proxmox packages. Both are linux-pam 1.7.2; the older build is also
    # loadable by processes using the newer system glibc.
    security.pam.package = lib.mkDefault pam;

    # The proxmox-ve buildEnv ships util-linux from nixpkgs-stable, so its
    # PAM binaries (login, runuser, chsh, chfn) are linked against the older
    # glibc. PVE's node shell runs `login` from the proxmox-ve PATH, which
    # then cannot load the system PAM modules. Use the matching util-linux
    # from the system nixpkgs instead.
    services.proxmox-ve.package = lib.mkDefault (
      pkgs.proxmox-ve.override {
        inherit (pkgs) util-linux;
      }
    );
  };
}
