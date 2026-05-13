{ config, ... }:
{
  age.secrets.vaultwarden.file = ../../../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      SMTP_FROM_NAME = "nat's vaultwarden";
      INVITATION_ORG_NAME = "nat's vaultwarden";
      SIGNUPS_ALLOWED = false;
      USER_ATTACHMENT_LIMIT = 1048576;
      ORG_ATTACHMENT_LIMIT = 1048576;
      DOMAIN = "https://vault.nekopon.pl";
      EMERGENCY_ACCESS_ALLOWED = false;
      SHOW_PASSWORD_HINT = false;
      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 9500;
      PUSH_ENABLED = true;
      SMTP_HOST = "smtp.postmarkapp.com";
      SMTP_FROM = "root@vault.nekopon.pl";
      EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "cxp-export-mobile,cxp-import-mobile,pm-25373-windows-biometrics-v2,pm-30529-webauthn-related-origins,pm-5594-safari-account-switching,ssh-agent,ssh-agent-v2,ssh-key-vault-item";
    };
  };

  services.caddy.virtualHosts."vault.nekopon.pl" = {
    logFormat = "output discard";
    extraConfig = ''
      import common

      header {
        X-XSS-Protection "0"
        X-Frame-Options "SAMEORIGIN"
        X-Robots-Tag "noindex, nofollow"
        X-Content-Type-Options "nosniff"
        -Server
        -X-Powered-By
        -Last-Modified
      }

      reverse_proxy [::1]:9500 { header_up X-Real-IP {remote_host} }
    '';
  };
}
