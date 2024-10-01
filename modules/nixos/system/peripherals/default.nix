{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.peripherals;
in
{
  options.${namespace}.system.peripherals = {
    enable = lib.mkEnableOption "peripherals";
  };

  config = lib.mkIf cfg.enable {
    # use CUPS for printing
    services.printing.enable = true;

    # enable sound
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # ref: https://github.com/fufexan/nix-gaming/#pipewire-low-latency
      lowLatency.enable = true;
    };
    security.rtkit.enable = true;

    # enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # opengl, graphics drivers
    hardware.graphics.enable32Bit = true;

    # enable location information services
    services.geoclue2.enable = true;
  };

}
