{ pkgs, ... }:
{
  systemd.timers.sing-box-restart = {
    wantedBy = [ "timers.target" ];
    description = "Restart sing-box service";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "sing-box-restart.service";
    };
  };

  systemd.services.sing-box-restart = {
    description = "Restart sing-box service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart sing-box.service";
      PermissionsStartOnly = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
    };
  };

}
