{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    extraConfig = ''
      font-size=11
      xkb-layout=pl
    '';
    fonts = [
      {
        name = "Cascadia Mono PL";
        package = pkgs.cascadia-code;
      }
    ];
  };
}
