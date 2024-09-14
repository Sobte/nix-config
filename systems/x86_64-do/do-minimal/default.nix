{
  namespace,
  ...
}:
{
  ${namespace} = {
    user.name = "root"; # use nixos as default user
    room.server.enable = true;
  };

  system.stateVersion = "24.11";
}
