{
  # default vars
  host = {
    name = "meow";
    nickname = "sobte";
    email = "i@sobte.me";
    sendEmail = {
      smtpserver = "pixel.mxrouting.net";
      smtpuser = "noreply@sobte.me";
    };
    samba.client = {
      # home nas config
      home-nas = {
        hostUrl = "home.nas.oop.icu";
        binds = {
          "home-resources" = { };
          "home-shared" = { };
        };
      };
    };
    signKey = "612A2672CCEDF205";
    # Because these keys can access all computers, 
    # they are generated using fido2 and require a passphrase.
    # and it is not movable
    authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIC28xE3cSlISUrxNy6tWuyoQciROmE794AI6Jm/XoariAAAADXNzaDpob21lLWNvZGU="
    ];
    # using toml here to benefit from schema & lsp
    starship.settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
  };
}
