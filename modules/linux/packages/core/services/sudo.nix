{ host, ... }:
{
  security.sudo.enable = true;
  users.users.${host.username} = {
    extraGroups = [ "wheel" ]; # for sudo
  };
}
