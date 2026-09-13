{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.printing = {
    enable = true;
    startWhenNeeded = false;
    stateless = true;
    webInterface = false;
  };

  hardware.printers = {
    ensureDefaultPrinter = "Library";
    ensurePrinters = lib.singleton {
      deviceUri = "ipp://skogsduva/ipp/print";
      model = "everywhere";
      name = "Library";
      ppdOptions = {
        Duplex = "DuplexNoTumble";
        PageSize = "A4";
      };
    };
  };

  systemd.services.ensure-printers = {
    after = [
      "network-online.target"
      "nss-lookup.target"
    ];
    wants = [ "network-online.target" ];
    wantedBy = lib.mkForce [ ];
    requires = [ "nss-lookup.target" ];
    startAt = "*-*-* *:05:00";

    script = lib.mkBefore ''
      if ! ${lib.getExe pkgs.curl} "skogsduva:631" &>/dev/null; then
        echo "Cannot setup printer. Host is down."
        exit 0
      fi

      if ${pkgs.cups}/bin/lpstat -p ${config.hardware.printers.ensureDefaultPrinter} &>/dev/null; then
        echo "Printer already configured."
        exit 0
      fi
    '';
  };
}
