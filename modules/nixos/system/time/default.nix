{
  lib,
  host,
  namespace,
  catteryNs,
  ...
}:
let
  isInfra =
    lib.hasPrefix "home-infra-" host
    || builtins.elem host [
      "do-minimal"
      "gce-minimal"
    ];
in
{
  ${catteryNs}.system.time.timeZone = lib.mkDefault (
    if isInfra then "UTC" else lib.${namespace}.host.timeZone
  );
}
