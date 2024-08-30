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
    nixfmt-rfc-style
    deadnix
    statix
  ];

  inherit (inputs.self.checks.${system}.pre-commit-check) shellHook;
  buildInputs = inputs.self.checks.${system}.pre-commit-check.enabledPackages;
}
