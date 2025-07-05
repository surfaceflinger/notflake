{ lib, pkgs, ... }:
{
  # doas
  security = {
    sudo.enable = lib.mkForce false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "root" ];
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };
  environment.systemPackages = [ pkgs.doas-sudo-shim ];
}
