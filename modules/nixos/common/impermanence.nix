{ inputs, ... }:
{
  imports = [ "${inputs.impermanence.result}/nixos.nix" ];

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    enableWarnings = false;
    hideMounts = true;
  };
}
