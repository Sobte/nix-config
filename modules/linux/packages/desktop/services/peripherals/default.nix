{
  # use CUPS for printing
  services.printing.enable = true;

  # enable sound
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  services.pipewire.enable = true;

  # the way to mount disks
  services.udisks2.enable = true;

  # opengl
  hardware.opengl.driSupport32Bit = true;
}
