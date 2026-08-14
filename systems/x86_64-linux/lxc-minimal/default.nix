{ catteryNs, ... }:
{
  ${catteryNs} = {
    user.name = "root"; # use nixos as default user
    room.container.enable = true;
  };
}
