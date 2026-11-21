{ pkgs, ... }:
let
  fields = [
    "adjusted_time"
    "alt_blocks_count"
    "block_size_limit"
    "block_size_median"
    "block_weight_limit"
    "block_weight_median"
    "busy_syncing"
    "credits"
    "cumulative_difficulty"
    "cumulative_difficulty_top64"
    "database_size"
    "difficulty"
    "difficulty_top64"
    "grey_peerlist_size"
    "height"
    "height_without_bootstrap"
    "incoming_connections_count"
    "mainnet"
    "offline"
    "outgoing_connections_count"
    "restricted"
    "rpc_connections_count"
    "start_time"
    "stagenet"
    "synchronized"
    "target"
    "target_height"
    "testnet"
    "tx_count"
    "tx_pool_size"
    "untrusted"
    "update_available"
    "was_bootstrap_ever_used"
    "white_peerlist_size"
  ];
in
{
  services.prometheus.exporters.json = {
    enable = true;
    listenAddress = "[::1]";
    configFile = (pkgs.formats.yaml { }).generate "json-exporter-config.yml" {
      modules.monero.metrics = map (field: {
        name = "monero_${field}";
        path = "{.${field}}";
        # the Config struct has no yaml tag, so the key is not value_type
        valuetype = "gauge";
      }) fields;
    };
  };
}
