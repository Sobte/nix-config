{
  inputs.nix-config.url = "github:Sobte/nix-config";
  outputs = { nix-config, ... }: {
    hydraJobs = nix-config.builds;
  };
}
