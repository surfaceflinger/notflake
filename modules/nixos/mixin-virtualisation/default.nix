{
  config,
  pkgs,
  ...
}:
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

  boot.extraModprobeConfig = ''
    options kvm_amd npt=1 avic=1 nested=1 sev=1
    options kvm ignore_msrs=1 report_ignored_msrs=0
    options kvm_intel nested=1 emulate_invalid_guest_state=0
  '';

  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
  ];
}
