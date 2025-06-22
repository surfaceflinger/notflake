{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.srvos.result}/shared/mixins/trusted-nix-caches.nix"
  ];

  nix = {
    channel.enable = false;
    package = pkgs.lixPackageSets.stable.lix;
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    settings = {
      auto-allocate-uids = true;
      use-xdg-base-directories = true;
      experimental-features = lib.mkForce [
        "auto-allocate-uids"
        "cgroups"
        "flakes"
        "nix-command"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "24.11";
}
