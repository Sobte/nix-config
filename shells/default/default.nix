{
  inputs,
  pkgs,
  mkShell,
  system,
  ...
}:
mkShell {
  packages = with pkgs; [
    # nix stuff
    nixfmt
    deadnix
    statix
    inputs.colmena.packages.${system}.colmena
  ];

  inherit (inputs.self.checks.${system}.pre-commit-check) shellHook;
  buildInputs = inputs.self.checks.${system}.pre-commit-check.enabledPackages;
}
