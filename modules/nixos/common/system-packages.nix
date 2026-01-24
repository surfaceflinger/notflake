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
    bat
    deadnix
    file
    flow-control
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
    tre
    (writeScriptBin "7z" ''exec 7zz "$@"'')
    yq-go

    # system utilities
    bottom
    busybox-nat
    config.boot.kernelPackages.cpupower
    systemctl-tui

    # network
    doggo
    goaccess
    speedtest-go
  ];
}
