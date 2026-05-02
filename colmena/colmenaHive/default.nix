{
  inputs,
  ...
}:
let
  deployments = import ./deployments.nix;
  conf = inputs.self.nixosConfigurations;
in
# reference: https://github.com/zhaofengli/colmena/issues/60#issuecomment-1510496861
inputs.colmena.lib.makeHive (
  {
    meta = {
      description = "personal machines";
      # This can be overriden by node nixpkgs
      nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      nodeNixpkgs = builtins.mapAttrs (_: value: value.pkgs) conf;
      nodeSpecialArgs = builtins.mapAttrs (_: value: value._module.specialArgs) conf;
    };
  }
  // (builtins.mapAttrs (name: value: {
    imports = value._module.args.modules;
    deployment = deployments.${name}.deployment or { };
  }) conf)
)
