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
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    package = pkgs.nixVersions.latest;
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
      http3 = true;
      experimental-features = lib.mkForce [
        "auto-allocate-uids"
        "cgroups"
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "26.05";
}
