{ inputs, ... }:
{
  services.caddy.virtualHosts."blahaj.pl".extraConfig = ''
    import common

    root * ${inputs.blahajpl-homepage.result}
    file_server
  '';
}
