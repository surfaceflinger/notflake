{ inputs, ... }:
{
  imports = [ "${inputs.agenix.result}/modules/age.nix" ];
  fileSystems."/etc/ssh".neededForBoot = true; # needed for tmpfs as root
}
