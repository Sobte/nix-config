{ inputs, ... }:
_: prev: {
  opencode = inputs.opencode.packages.${prev.system}.default.override {
    inherit (inputs.self.packages.${prev.system}) bun;
  };
}
