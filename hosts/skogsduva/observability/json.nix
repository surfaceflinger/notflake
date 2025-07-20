{ pkgs, ... }:
{
  services.prometheus.exporters.json = {
    enable = true;
    listenAddress = "[::1]";
    configFile = (pkgs.formats.yaml { }).generate "json-exporter-config.yml" {
      modules.monero = {
        metrics = [
          {
            name = "monero_adjusted_time";
            path = "{.adjusted_time}";
            help = "Adjusted time from Monero get_info";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_alt_blocks_count";
            path = "{.alt_blocks_count}";
            help = "Alternative blocks count";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_block_size_limit";
            path = "{.block_size_limit}";
            help = "Block size limit";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_block_size_median";
            path = "{.block_size_median}";
            help = "Block size median";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_block_weight_limit";
            path = "{.block_weight_limit}";
            help = "Block weight limit";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_block_weight_median";
            path = "{.block_weight_median}";
            help = "Block weight median";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_credits";
            path = "{.credits}";
            help = "Credits";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_cumulative_difficulty";
            path = "{.cumulative_difficulty}";
            help = "Cumulative difficulty";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_cumulative_difficulty_top64";
            path = "{.cumulative_difficulty_top64}";
            help = "Cumulative difficulty top64";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_database_size";
            path = "{.database_size}";
            help = "Database size";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_difficulty";
            path = "{.difficulty}";
            help = "Difficulty";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_difficulty_top64";
            path = "{.difficulty_top64}";
            help = "Difficulty top64";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_free_space";
            path = "{.free_space}";
            help = "Free space";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_grey_peerlist_size";
            path = "{.grey_peerlist_size}";
            help = "Grey peerlist size";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_height";
            path = "{.height}";
            help = "Blockchain height";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_height_without_bootstrap";
            path = "{.height_without_bootstrap}";
            help = "Height without bootstrap";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_incoming_connections_count";
            path = "{.incoming_connections_count}";
            help = "Incoming connections count";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_mainnet";
            path = "{.mainnet}";
            help = "Mainnet status (1=true, 0=false)";
            type = "value";
            value_type = "value";
            value = "1 if true else 0";
          }
          {
            name = "monero_outgoing_connections_count";
            path = "{.outgoing_connections_count}";
            help = "Outgoing connections count";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_restricted";
            path = "{.restricted}";
            help = "Restricted status (1=true, 0=false)";
            type = "value";
            value_type = "value";
            value = "1 if true else 0";
          }
          {
            name = "monero_rpc_connections_count";
            path = "{.rpc_connections_count}";
            help = "RPC connections count";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_start_time";
            path = "{.start_time}";
            help = "Start time";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_status_ok";
            path = "{.status}";
            help = "Status OK (1 if OK else 0)";
            type = "value";
            value_type = "value";
            value = "1 if value == 'OK' else 0";
          }
          {
            name = "monero_synchronized";
            path = "{.synchronized}";
            help = "Synchronized status (1=true, 0=false)";
            type = "value";
            value_type = "value";
            value = "1 if true else 0";
          }
          {
            name = "monero_target";
            path = "{.target}";
            help = "Target";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_target_height";
            path = "{.target_height}";
            help = "Target height";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_tx_count";
            path = "{.tx_count}";
            help = "Transaction count";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_tx_pool_size";
            path = "{.tx_pool_size}";
            help = "Transaction pool size";
            type = "value";
            value_type = "value";
          }
          {
            name = "monero_white_peerlist_size";
            path = "{.white_peerlist_size}";
            help = "White peerlist size";
            type = "value";
            value_type = "value";
          }
        ];
      };
    };
  };
}
