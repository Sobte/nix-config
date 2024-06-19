{ host, ... }:
{
  imports = [
    ./sddm
    ./plasma
  ];

  home-manager = {
    users.${host.username}.imports = [ ./kwalletcli/home.nix ];
  };
}
