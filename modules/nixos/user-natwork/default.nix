{
  config,
  inputs,
  lib,
  pkgs,
  homeModules,
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
      "podman"
    ];
    packages =
      with pkgs;
      [
        argocd
        awscli2
        awsume
        buildah
        cfn-nag
        eksctl
        gnumake
        (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
        inputs.cfn-changeset-viewer.result.packages."${config.nixpkgs.hostPlatform.system}".default
        inputs.tf.result.packages."${config.nixpkgs.hostPlatform.system}"."1.5.7"
        k9s
        kubectl
        kubernetes-helm
        mariadb
        opentofu
        postgresql
        siege
        ssm-session-manager-plugin
        teleport
      ]
      ++ lib.optionals config.xdg.portal.enable [
        beekeeper-studio
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
      imports = [
        homeModules.common
      ] ++ lib.optionals config.xdg.portal.enable [ homeModules.desktop ];

      dconf.settings."org/gnome/shell/extensions/appindicator".legacy-tray-enabled = true;

      services.podman.enable = true;
    };

  programs.zsh.shellAliases = {
    awsume = ". ${lib.getExe pkgs.awsume}";
    changeset = "${
      lib.getExe
        inputs.cfn-changeset-viewer.result.packages."${config.nixpkgs.hostPlatform.system}".default
    } --change-set-name";
  };
}
