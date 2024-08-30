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
    hardware.pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    services.pipewire.enable = true;

    # the way to mount disks
    services.udisks2.enable = true;

    # opengl, graphics drivers
    hardware.graphics.enable32Bit = true;
  };

}
