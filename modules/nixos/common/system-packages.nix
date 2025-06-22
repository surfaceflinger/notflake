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
    inputs.nilla-cli.result.packages.default.result."${config.nixpkgs.hostPlatform.system}"
    inputs.nilla-utils.result.packages.default.result."${config.nixpkgs.hostPlatform.system}"
    ipgrep
    jq
    lurk
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
    wget
    (writeScriptBin "7z" ''exec 7zz "$@"'')
    yq-go

    # system utilities
    bottom
    config.boot.kernelPackages.cpupower
    pciutils
    psmisc
    usbutils

    # network
    doggo
    goaccess
    inetutils
    magic-wormhole-rs
    rustscan
    speedtest-go
    wavemon
  ];
}
