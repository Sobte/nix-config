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
    authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPZsxQz6l4pHNXMHMbj9Vp3aOACZnmBK3qT4r7DxWRZZAAAADnNzaDppQHNvYnRlLm1l"
    ];
    # using toml here to benefit from schema & lsp
    starship.settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
  };
}
