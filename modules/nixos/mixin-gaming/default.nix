{ pkgs, ... }:
{
  boot = {
    kernelModules = [ "ntsync" ];
    kernel.sysctl = {
      # remove artificial penalties for split locks, which is useful for games run
      # through proton.
      # https://www.phoronix.com/news/linux-splitlock-hurts-gaming
      "kernel.split_lock_mitigate" = 0;
    };
  };

  environment.sessionVariables = {
    # enable wine wayland and hdr
    PROTON_ENABLE_HDR = 1;
    PROTON_ENABLE_WAYLAND = 1;
    PROTON_USE_NTSYNC = 1;
  };

  # packs
  environment.systemPackages = with pkgs; [
    furmark # upalarnia pl
    jazz2 # i maintain this, ok?
    lunar-client # minecraft with spyware
    mcpelauncher-ui-qt # minecraft with more spyware
    pcsx2 # ps2 emu
    rpcs3 # ps3 emu
    steamguard-cli # steam MFA
    (prismlauncher.override {
      jdks = [
        jdk8
        jdk21
      ];
    }) # minecraft (good one)
  ];

  # for roblox
  services.flatpak.enable = true;

  # gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # steam
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    extest.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    extraPackages = with pkgs; [
      nspr
      nss
      steamtinkerlaunch
      winetricks
    ];
    gamescopeSession.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
  };

  # controller rules
  hardware.steam-hardware.enable = true;
  services.udev.packages = with pkgs; [ game-devices-udev-rules ];
}
