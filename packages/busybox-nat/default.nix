{ busybox, symlinkJoin }:
let
  busybox' = busybox.override { enableAppletSymlinks = false; };
in
symlinkJoin {
  name = "busybox-nat";
  inherit (busybox') version;
  paths = [ busybox' ];
  postBuild = ''
    tools=(
      "ftpd"
      "ftpget"
      "ftpput"
      "fuser"
      "ifconfig"
      "killall"
      "lspci"
      "lsscsi"
      "lsusb"
      "nc"
      "netstat"
      "pstree"
      "telnet"
      "tftp"
      "traceroute"
      "traceroute6"
      "wget"
      "whois"
    )

    mkdir -p $out/bin
    for tool in "''${tools[@]}"; do
      ln -s "${busybox}/bin/busybox" "$out/bin/$tool"
    done
  '';
}
