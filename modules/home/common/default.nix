{ inputs, pkgs, ... }: {
  imports = [
    ./git.nix
    inputs.dont-track-me.result.homeManagerModules.default
    inputs.nix-index-database.result.homeModules.nix-index
  ];

  home.stateVersion = "26.05";

  # the module also links the full database into ~/.cache/nix-index
  programs.nix-index.symlinkToCacheHome = false;

  # full nix-index database costs ~180 MiB; the small one is good enough
  programs.nix-index.package =
    inputs.nix-index-database.result.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;

  dont-track-me = {
    enable = true;
    enableAll = true;
  };

  # hashicorp tools (packer) phone home through checkpoint
  home.sessionVariables.CHECKPOINT_DISABLE = "1";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "10min";
    options = "--delete-older-than 7d";
  };
}
