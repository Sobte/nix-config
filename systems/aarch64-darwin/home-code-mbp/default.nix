{
  namespace,
  ...
}:
{
  ${namespace} = {
    room.desktop.dev.enable = true;
    services.wg-quick = {
      enable = true;
      configNames = [ "wg-go-home" ];
    };
    shared.services.sing-box.enable = true;
  };
}
