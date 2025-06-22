{ inputs, ... }:
let
  server_name = "nekopon.pl";
  matrix_hostname = "matrix.${server_name}";
  address = "::1";
  port = 6167;
in
{
  imports = [ inputs.grapevine.result.nixosModules.default ];

  services.grapevine = {
    enable = true;
    settings = {
      inherit server_name;
      conduit_compat = true;

      # database
      database.backend = "rocksdb";

      # networking
      max_request_size = 52428800;
      federation = {
        max_concurrent_requests = 10000;
        self_test = false;
      };
      listen = [
        {
          inherit address port;
          type = "tcp";
        }
      ];
      server_discovery = {
        server.authority = "${matrix_hostname}:443";
        client = {
          advertise_buggy_sliding_sync = true;
          base_url = "https://${matrix_hostname}";
        };
      };

      # misc
      allow_registration = false;
    };
  };

  services.caddy.virtualHosts."${server_name}".extraConfig = ''
    handle_path /.well-known/matrix/* {
      respond /server `{"m.server": "${matrix_hostname}:443"}`
      respond /client `{"m.homeserver": {"base_url": "https://${matrix_hostname}"}, "org.matrix.msc3575.proxy": {"url": "https://${matrix_hostname}"}}`
    }
  '';

  services.caddy.virtualHosts."${matrix_hostname}".extraConfig = ''
    redir / https://${server_name}
    reverse_proxy [${address}]:${toString port}
  '';
}
