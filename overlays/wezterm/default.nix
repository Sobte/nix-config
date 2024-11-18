{ inputs, ... }:
_: prev: {
  # https://github.com/wez/wezterm/issues/5990
  wezterm = inputs.wezterm.packages.${prev.system}.default;
}
