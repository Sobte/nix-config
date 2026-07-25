{ inputs, ... }:
{
  enable = true;
  secretsPath = "${inputs.hosts-secrets}";
}
