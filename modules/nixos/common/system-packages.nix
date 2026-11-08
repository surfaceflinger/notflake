{
  config,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;

  # the release binary embeds rust-src paths in panic messages, dragging the
  # whole fenix nightly toolchain (~2 GiB) into the system closure
  nilla-cli = pkgs.runCommandLocal "nilla" { nativeBuildInputs = [ pkgs.removeReferencesTo ]; } ''
    cp -a ${inputs.nilla-cli.result.packages.default.result.${system}}/. $out/
    chmod -R u+w $out
    for path in $(grep -ao '/nix/store/[a-z0-9]\{32\}-rust-nightly-complete[^/]*' $out/bin/nilla | cut -d/ -f1-4 | sort -u); do
      remove-references-to -t "$path" $out/bin/nilla
    done
  '';
in
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
    nilla-cli
    inputs.nilla-utils.result.packages.default.result.${system}
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
