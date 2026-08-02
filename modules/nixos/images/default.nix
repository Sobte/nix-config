{
  inputs,
  ...
}:
let
  mkFixedImage =
    name: modulePath: builderAttr: product:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        (inputs.nixpkgs.outPath + "/${modulePath}")
      ];
      system.build.image = lib.mkForce (
        pkgs.runCommand "${name}-hydra" { } ''
          mkdir -p $out/nix-support
          ln -s ${config.system.build.${builderAttr}}/${config.image.filePath} $out/${config.image.filePath}
          echo "file ${product} $out/${config.image.filePath}" > $out/nix-support/hydra-build-products
        ''
      );
    };
in
{
  config.image.modules = {
    digital-ocean-fixed =
      mkFixedImage "digital-ocean-fixed" "nixos/modules/virtualisation/digital-ocean-image.nix"
        "digitalOceanImage"
        "qcow2-image";
    google-compute-fixed =
      mkFixedImage "google-compute-fixed" "nixos/modules/virtualisation/google-compute-image.nix"
        "googleComputeImage"
        "raw-image";
  };
}
