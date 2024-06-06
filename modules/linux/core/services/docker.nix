{ ... }:
{
  # the program that i have to use to do any work
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
}
