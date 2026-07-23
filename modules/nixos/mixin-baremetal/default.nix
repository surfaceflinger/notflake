{ inputs, ... }: {
  imports = [ inputs.autoaspm.result.nixosModules.default ];

  # save power by enabling the deepest ASPM state each pcie device supports
  services.autoaspm.enable = true;
}
