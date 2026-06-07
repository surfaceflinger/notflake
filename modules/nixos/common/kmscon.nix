{ pkgs, ... }: {
  services.kmscon = {
    enable = true;
    config = {
      font-size = 11;
      xkb-layout = "pl";
      font-name = "Cascadia Mono PL";
    };
  };

  fonts.packages = [ pkgs.cascadia-code ];
}
