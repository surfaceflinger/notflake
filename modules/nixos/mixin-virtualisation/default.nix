{ config, pkgs, ... }:
{
  programs.virt-manager.enable = config.xdg.portal.enable;

  virtualisation = {
    spiceUSBRedirection.enable = config.xdg.portal.enable;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
  ];
}
