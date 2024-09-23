{ lib }:
let
  inherit (lib)
    splitString
    sublist
    concatStringsSep
    ;
in
{
  findNixPaths =
    dir:
    builtins.map (f: (dir + "/${f}")) (
      builtins.filter (file: builtins.match ".+\\.nix" file != null) (
        builtins.attrNames (builtins.readDir dir)
      )
    );

  getRootDomain =
    domain:
    let
      names = splitString "." domain;
      length = builtins.length names;
      root = sublist (length - 2) (length - 1) names;
    in
    concatStringsSep "." root;
}
