{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ "${inputs.srvos.result}/shared/mixins/trusted-nix-caches.nix" ];

  nix = {
    channel.enable = false;
    package = pkgs.lixPackageSets.stable.lix;
    registry = lib.mapAttrs (name: input: {
      from = {
        type = "indirect";
        id = name;
      };
      to = {
        type = "path";
        path = input.src;
      };
    }) { "nixpkgs" = inputs.nixpkgs; };
    settings = {
      allowed-users = [ "@users" ];
      auto-allocate-uids = true;
      nix-path = lib.mkForce [ "nixpkgs=flake:nixpkgs" ];
      use-cgroups = true;
      use-xdg-base-directories = true;
      experimental-features = lib.mkForce [
        "auto-allocate-uids"
        "cgroups"
        "flakes"
        "nix-command"
        "pipe-operator"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "24.11";
}
