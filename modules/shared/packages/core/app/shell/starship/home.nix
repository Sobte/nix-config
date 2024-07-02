{
  programs = {
    # used to use headline, tho kinda slow, so switched to starship
    starship = {
      enable = true;
      # using toml here to benefit from schema & lsp
      settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
    };
  };
}
