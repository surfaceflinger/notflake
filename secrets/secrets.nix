let
  host-skogsduva = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFC2wynlCNvuMdeXAGp0ce1gds3SXJgy/7cRINFK1bR";
  host-jattelik = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbKC5x6WVnOklmnbu/7jIkKtBBhutIdwmF7tweA6i14";
  user-nat-blahaj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACA/8h6byidHxDaO0kMWHdKYYpPwRW1nrVPOZr90YiW";
in
{
  "xkomhotshot.age".publicKeys = [
    host-skogsduva
    user-nat-blahaj
  ];
  "googlebackup.age".publicKeys = [
    host-jattelik
    user-nat-blahaj
  ];
  "vaultwarden.age".publicKeys = [
    host-jattelik
    user-nat-blahaj
  ];
  "wastebin.age".publicKeys = [
    host-jattelik
    user-nat-blahaj
  ];
  "litestream-jattelik.age".publicKeys = [
    host-jattelik
    user-nat-blahaj
  ];
  "caddy-desec-jattelik.age".publicKeys = [
    host-jattelik
    user-nat-blahaj
  ];
}
