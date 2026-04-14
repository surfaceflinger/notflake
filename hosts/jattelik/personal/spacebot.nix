{ config, inputs, ... }:
{
  imports = [ inputs.spacebot.result.nixosModules.default ];

  age.secrets.spacebot-jattelik.file = ../../../secrets/spacebot-jattelik.age;

  services.spacebot = {
    enable = true;
    environmentFile = config.age.secrets.spacebot-jattelik.path;
    hardening = true;
  };

  services.caddy.virtualHosts."https://spacebot.natalia.ovh".extraConfig = ''
    import common

    bind [fd7a:115c:a1e0::1201:4104] [::1]
    tls internal

    reverse_proxy http://${config.services.spacebot.bind}:${toString config.services.spacebot.port}
  '';
}
