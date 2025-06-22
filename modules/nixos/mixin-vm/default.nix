{
  config,
  modulesPath,
  ...
}:
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  services = {
    qemuGuest.enable = true;
    spice-autorandr.enable = config.xdg.portal.enable;
    spice-vdagentd.enable = config.xdg.portal.enable;
    spice-webdavd.enable = config.xdg.portal.enable;
  };
}
