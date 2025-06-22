{ inputs, ... }:
{
  services.caddy.virtualHosts."blahaj.pl".extraConfig = ''
    root * ${inputs.blahajpl-homepage.result}
    file_server
  '';
}
