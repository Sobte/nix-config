{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # rustdesk
      rustdesk
      # kde
      kdePackages.krdc
      # gnome
      remmina
    ];
  };
}
