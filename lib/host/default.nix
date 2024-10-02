{
  # default vars
  host = {
    name = "meow";
    nickname = "sobte";
    email = "i@sobte.me";
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
    authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPZsxQz6l4pHNXMHMbj9Vp3aOACZnmBK3qT4r7DxWRZZAAAADnNzaDppQHNvYnRlLm1l"
    ];
    # using toml here to benefit from schema & lsp
    starship.settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
  };
}
