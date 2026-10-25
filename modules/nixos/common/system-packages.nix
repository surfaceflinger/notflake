{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # other software
  environment.systemPackages = with pkgs; [
    # cli/tui tools
    _7zz
    abduco
    aria2
    bat
    deadnix
    file
    inputs.nilla-cli.result.packages.default.result."${pkgs.stdenv.hostPlatform.system}"
    inputs.nilla-utils.result.packages.default.result."${pkgs.stdenv.hostPlatform.system}"
    jq
    lurk
    magic-wormhole-rs
    ncdu
    nixfmt
    npins
    pv
    rage
    ripgrep
    shellcheck
    statix
    tealdeer
    tre-command
    (writeScriptBin "7z" ''exec 7zz "$@"'')
    yq-go

    # system utilities
    bottom
    config.boot.kernelPackages.cpupower
    cyme
    e2fsprogs.bin
    pciutils
    procs
    systemctl-tui

    # network
    doggo
    goaccess
    rdap
    speedtest-go
    trippy
  ];
}
