{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.copyparty.result.nixosModules.default ];

  age.secrets.copyparty-azsurv = {
    file = ../../../secrets/copyparty-azsurv.age;
    owner = "copyparty";
  };

  services.copyparty = {
    enable = true;

    package = pkgs.copyparty.override {
      ffmpeg = pkgs.ffmpeg-headless;
      withCertgen = false;
      withFTP = false;
      withZeroMQ = false;
    };

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
      "/misc/AzerothSurvivors" = {
        path = "/srv/fileshare/misc/AzerothSurvivors";
        access = {
          r = "*";
          rwmd = "azsurv";
        };
      };
    };
    accounts = {
      azsurv.passwordFile = config.age.secrets.copyparty-azsurv.path;
    };
  };

  services.caddy.virtualHosts."files.blahaj.pl".extraConfig = ''
    import common

    reverse_proxy http://[::1]:3923
  '';
}
