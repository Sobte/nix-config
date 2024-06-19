{
  networking = {
    wireless.iwd.enable = true; # Enables wireless support.
    networkmanager = {
      wifi.backend = "iwd";
    };
  };
}
