{
  # default vars
  host = {
    name = "meow";
    git = {
      name = "sobte";
      email = "i@sobte.me";
    };
    samba.clients = {
      # home nas config
      home-nas = {
        hostUrl = "home.nas.oop.icu";
        binds = {
          "home-resources" = { };
          "home-shared" = { };
        };
      };
    };
    authorizedKeys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPZsxQz6l4pHNXMHMbj9Vp3aOACZnmBK3qT4r7DxWRZZAAAADnNzaDppQHNvYnRlLm1l meow@home-code-nixos"
    ];
  };
}
