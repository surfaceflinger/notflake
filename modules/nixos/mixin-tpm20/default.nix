{ config, ... }: {
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  users.groups."tss".members = config.users.groups."wheel".members;
}
