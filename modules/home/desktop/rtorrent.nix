{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  stateDirectory = "${config.xdg.stateHome}/rtorrent";
  defaultDownloadDirectory = "/vol/ikea/Other";

  downloadDirectories = [
    defaultDownloadDirectory
    "${config.home.homeDirectory}/Downloads"
    "${config.home.homeDirectory}/Torrents"
    "/vol/ikea/Media/Music/DL"
    "/vol/ikea/Media/Videos/Anime"
    "/vol/ikea/Media/Videos/Other"
    "/vol/ikea/Other/Torrents"
  ];

  configFile = pkgs.writeText "rtorrent.rc" ''
    network.listen.port.range.set = 51413-51413
    network.listen.port.random.set = no

    session.path.set = ${stateDirectory}
    directory.default.set = ${defaultDownloadDirectory}
    system.file.allocate.set = 1

    schedule = monitor_diskspace, 15, 60, ((close_low_diskspace, 1000M))

    log.open_file = "log", ${stateDirectory}/rtorrent.log
    log.add_output = "errors", "log"
  '';
in
{
  home.packages = [
    inputs.rtremotesf.result.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.rtorrent
  ];

  systemd.user.tmpfiles.rules = [ "d ${config.home.homeDirectory}/Torrents 0755 - - -" ];

  systemd.user.services.rtorrent = {
    Unit.Description = "rtorrent BitTorrent client";

    # No Install.WantedBy on purpose: the unit is stopped by default.
    # Start it manually with: systemctl --user start rtorrent
    Service = {
      Type = "simple";
      # rtorrent polls stdin with epoll, which rejects regular files such as
      # /dev/null, so feed it a pipe and keep rtorrent as the main process.
      ExecStart = "${lib.getExe pkgs.bash} -c 'exec ${lib.getExe pkgs.rtorrent} -n -o import=${configFile} -o network.scgi.open_local=%t/rtorrent/rtorrent.sock < <(exec ${pkgs.coreutils}/bin/sleep infinity)'";
      WorkingDirectory = stateDirectory;

      # sockets are allocated per category from this ulimit
      LimitNOFILE = 16384;

      StateDirectory = "rtorrent";
      StateDirectoryMode = "0700";
      RuntimeDirectory = "rtorrent";
      RuntimeDirectoryMode = "0700";

      Restart = "on-failure";
      RestartSec = 5;

      StandardOutput = "null";
      StandardError = "journal";
      SyslogIdentifier = "rtorrent";

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectHostname = true;
      ProtectProc = "invisible";
      PrivateTmp = true;
      PrivateDevices = true;
      DevicePolicy = "closed";
      RemoveIPC = true;

      CapabilityBoundingSet = "";
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@mount"
        "~@debug"
        "~@cpu-emulation"
        "~@obsolete"
        "~@raw-io"
        "~@reboot"
        "~@swap"
        "~@module"
      ];
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
        "AF_UNIX"
      ];

      ReadWritePaths = [ stateDirectory ] ++ downloadDirectories;
    };
  };
}
