{
  lib,
  config,
  namespace,
  catteryNs,
  inputs,
  ...
}:
let
  inherit (config.${catteryNs}.user) name;

  accounts = inputs.hosts-secrets.lib.settings.accounts;

  cfg = config.${namespace}.user.calendar;
in
{
  options.${namespace}.user.calendar = {
    enable = lib.mkEnableOption "calendar and contacts accounts";
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs} = {
      secrets.shared.users.${name}.files = {
        "calendar/password" = { };
        "contact/password" = { };
      };

      user = {
        calendar = [
          {
            remote = {
              type = "caldav";
              inherit (accounts.calendar) url userName;
              passwordCommand = [
                "cat"
                config.${catteryNs}.secrets.shared.users.${name}.files."calendar/password".path
              ];
            };
          }
        ];
        contact = [
          {
            remote = {
              type = "carddav";
              inherit (accounts.contact) url userName;
              passwordCommand = [
                "cat"
                config.${catteryNs}.secrets.shared.users.${name}.files."contact/password".path
              ];
            };
          }
        ];
      };
    };
  };
}
