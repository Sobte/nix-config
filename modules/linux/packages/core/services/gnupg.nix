{
  # SUID wrapper, not sure if i need this, but just to not bother my future self
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
