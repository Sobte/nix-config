{
  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "0/4:0"; # expands to "*-*-* 00/04:00:00"
      randomizedDelaySec = "45min";
      options = "--delete-older-than 30d";
    };
  };
}
