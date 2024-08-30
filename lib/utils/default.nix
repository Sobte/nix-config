{
  findNixPaths =
    dir:
    builtins.map (f: (dir + "/${f}")) (
      builtins.filter (file: builtins.match ".+\\.nix" file != null) (
        builtins.attrNames (builtins.readDir dir)
      )
    );
}
