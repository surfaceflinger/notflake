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
    nixPath = lib.mkForce [
      "nixpkgs=flake:nixpkgs"
      "tf=flake:tf"
    ];
    registry =
      lib.mapAttrs
        (name: input: {
          from = {
            type = "indirect";
            id = name;
          };
          to = {
            type = "path";
            path = input.src;
          };
        })
        {
          "nixpkgs" = inputs.nixpkgs;
          "tf" = inputs.tf;
        };
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
