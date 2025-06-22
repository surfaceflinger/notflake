{ config, lib, ... }:
let
  bucket = "jattelik-litestream-qxhvhtiw.s3.fr-par.scw.cloud";
in
{
  # cope
  systemd.services.litestream.serviceConfig.User = lib.mkForce "root";

  services.litestream = {
    enable = true;
    environmentFile = config.age.secrets.litestream-jattelik.path;
    settings = {
      dbs = [
        {
          path = config.services.gotosocial.settings.db-address;
          replicas = [
            {
              url = "s3://${bucket}/gotosocial";
            }
          ];
        }
        {
          path = "/var/lib/private/wastebin/sqlite3.db";
          replicas = [
            {
              url = "s3://${bucket}/wastebin";
            }
          ];
        }
        {
          path = "/var/lib/vaultwarden/db.sqlite3";
          replicas = [
            {
              url = "s3://${bucket}/vaultwarden";
            }
          ];
        }
        {
          path = "/var/lib/private/soju/soju.db";
          replicas = [
            {
              url = "s3://${bucket}/soju";
            }
          ];
        }
      ];
    };
  };

  age.secrets.litestream-jattelik.file = ../../secrets/litestream-jattelik.age;
}
