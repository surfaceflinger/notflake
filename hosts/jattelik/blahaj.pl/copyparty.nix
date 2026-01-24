{ inputs, ... }:
{
  imports = [ inputs.copyparty.result.nixosModules.default ];

  services.copyparty = {
    enable = true;
    settings = {
      i = "::1";
      name = "files.blahaj.pl";
      p = [ 3923 ];
      rproxy = 1;
      http-only = true;
      reflink = true;
      e2d = true;
      e2dsa = true;
      e2ts = true;
      opds = true;
      xdev = true;
      xvol = true;
      no-zip = true;
      no-tarcmp = true;
      gsel = true;
    };
    volumes = {
      "/setool" = {
        path = "/srv/fileshare/setool";
        access = {
          r = "*";
        };
      };
      "/misc" = {
        path = "/srv/fileshare/misc";
        access = {
          r = "*";
        };
      };
    };
  };

  services.caddy.virtualHosts."files.blahaj.pl".extraConfig = ''
    import common

    reverse_proxy http://[::1]:3923
  '';
}
