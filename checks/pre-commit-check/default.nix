{ inputs, system, ... }:
inputs.pre-commit-hooks.lib.${system}.run {
  src = ../../.;
  hooks = {
    # formatter
    nixfmt.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
