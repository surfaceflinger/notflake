{
  config,
  homeModules,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  users.users.natwork = {
    uid = 1112;
    initialHashedPassword = "$6$L/BOe/brf592ULhC$aoO9LPG6YoTlqOoJYh588S1vq7ejtuTY.myBiBt638.zo4IzpmiadnYKlg4xGV.x6NgOBZaSyCzNzzHLUjQq9/";
    isNormalUser = true;
    extraGroups = [
      "audio"
      "libvirtd"
      "networkmanager"
    ];
    packages =
      with pkgs;
      [
        argocd
        awscli2
        awsume
        buildah
        cfn-changeset-viewer
        cfn-nag
        dyff
        eksctl
        gnumake
        (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
        inputs.nixpkgs-tofu.result.legacyPackages."${pkgs.stdenv.hostPlatform.system}".opentofu
        inputs.nixpkgs-tofu.result.legacyPackages."${pkgs.stdenv.hostPlatform.system}".terragrunt
        inputs.tf.result.packages."${pkgs.stdenv.hostPlatform.system}"."1.5.7"
        k9s
        kubectl
        kubernetes-helm
        mariadb
        postgresql
        rain
        siege
        ssm-session-manager-plugin
      ]
      ++ lib.optionals config.xdg.portal.enable [
        bitwarden
        brave
        freerdp
        obs-studio
        slack
        timedoctor-desktop
      ];
  };

  home-manager.users.natwork =
    { ... }:
    {
      imports = [ homeModules.common ] ++ lib.optionals config.xdg.portal.enable [ homeModules.desktop ];

      dconf.settings."org/gnome/shell/extensions/appindicator".legacy-tray-enabled = true;

      services.podman.enable = true;
    };

  programs.zsh.shellAliases = {
    awsume = ". ${lib.getExe pkgs.awsume}";
    changeset = "${lib.getExe pkgs.cfn-changeset-viewer} --change-set-name";
  };
}
