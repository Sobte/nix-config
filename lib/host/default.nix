{
  # default vars
  host = {
    name = "meow";
    realName = "sobte";
    email = {
      address = "i@sobte.me";
      smtp.host = "pixel.mxrouting.net";
      imap.host = "pixel.mxrouting.net";
    };
    sendEmail = {
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
    gpg = {
      signKey = "612A2672CCEDF205";
      encryptKey = "FEE8B702D71CAEB0";
    };
    # Because these keys can access all computers, 
    # they are generated using fido2 and require a passphrase.
    # and it is not movable
    authorizedKeys.keys = [
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBCAtuUN2HxfkpZ5VKpZ3ZUrPT27Hj07WfJNGQXvnZ2626eLq1RR/cJfvoWbpKwPdAtbt1LATP+5D1XEfcFJGMjWKCKEWZIQjQ/Yes6dl65yHfwRemhlA0ERupZIkSaWZSg=="
    ];
    # using toml here to benefit from schema & lsp
    starship.settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
    wezterm.extraConfig = builtins.readFile ./config/wezterm.lua;
  };
}
