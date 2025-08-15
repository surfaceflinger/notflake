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
    inputs.nilla-cli.result.packages.default.result."${pkgs.system}"
    inputs.nilla-utils.result.packages.default.result."${pkgs.system}"
    jq
    lurk
    magic-wormhole-rs
    ncdu
    nixfmt-rfc-style
    npins
    pv
    rage
    ripgrep
    safe-rm-nat
    shellcheck
    statix
    tre
    (writeScriptBin "7z" ''exec 7zz "$@"'')
    yq-go

    # system utilities
    bottom
    busybox-nat
    config.boot.kernelPackages.cpupower

    # network
    doggo
    goaccess
    speedtest-go
  ];
}
