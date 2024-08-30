{ inputs, system, ... }:
inputs.pre-commit-hooks.lib.${system}.run {
  src = ../../.;
  hooks = {
    # formatter
    nixfmt-rfc-style.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
