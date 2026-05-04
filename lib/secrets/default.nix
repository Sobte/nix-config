{ inputs, ... }:
{
  secrets = {
    enable = true;
    secretsPath = "${inputs.hosts-secrets}";
  };
}
