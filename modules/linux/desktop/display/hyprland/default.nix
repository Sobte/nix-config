{
  imports = [ ../../../wayland.nix ];

  # hyprland and wayland
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };
}
