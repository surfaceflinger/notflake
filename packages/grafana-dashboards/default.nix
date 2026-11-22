{
  fetchurl,
  jq,
  lib,
  runCommandLocal,
  yq-go,
}:
let
  datasourceUid = "skogsduva-prometheus";

  # grafana.com dashboards ask for their prometheus input under a few different
  # names; resolve all of them, then strip the import metadata so the file
  # provider can load the dashboard directly.
  placeholder = ''"^[$][{](?i:ds_prometheus|datasource)[}]$"'';
  datasourceVariable = ''"^(?i:ds_prometheus|datasource)$"'';

  normalize = ''
    walk(
      if type == "object" and (.datasource | type) == "string" and (.datasource | test(${placeholder}))
      then .datasource = { type: "prometheus", uid: $ds }
      else . end
    )
    | walk(
        if type == "object" and (.uid | type) == "string" and (.uid | test(${placeholder}))
        then .uid = $ds
        else . end
      )
    | del(.templating.list[]? | select(.type == "datasource" and (.name | test(${datasourceVariable}))))
    | del(.__inputs, .__requires, .id, .version)
    | .uid = $uid
    | if [.. | strings | select(test("[$][{][Dd][Ss]_"))] | length > 0
      then error("unresolved datasource placeholder, map it in the placeholder list")
      else . end
    | select((.title | type) == "string" and .title != "" and (.panels | type) == "array")
  '';

  # bump a revision here and rebuild; the hash mismatch prints the new hash
  remote = [
    {
      id = 1860;
      revision = 46;
      uid = "node-exporter-full";
      hash = "sha256-5Y3cXcU11MkB+U2pZIvD49Wue2946Y4YW86LKJlhzqM=";
    }
    {
      id = 18153;
      revision = 4;
      uid = "asus-openwrt-router";
      hash = "sha256-6MUALz6C+nc5z01pT7K9AkHTsTjSVlc8ec8T/RzrJxw=";
    }
    {
      id = 22870;
      revision = 3;
      uid = "caddy";
      hash = "sha256-T/oImuRQrEGWLlaaMnBVNFNeAoKR1j1IiDoAlGmYnPU=";
    }
  ];

  remoteDashboard =
    {
      id,
      revision,
      uid,
      hash,
    }:
    {
      inherit uid;
      src = fetchurl {
        name = "${uid}.json";
        url = "https://grafana.com/api/dashboards/${toString id}/revisions/${toString revision}/download";
        inherit hash;
      };
    };

  localDashboard = name: {
    uid = lib.removeSuffix ".yaml" (lib.removeSuffix ".yml" name);
    src = ./dashboards + "/${name}";
  };

  local =
    builtins.readDir ./dashboards
    |> lib.filterAttrs (
      name: type: type == "regular" && (lib.hasSuffix ".yaml" name || lib.hasSuffix ".yml" name)
    )
    |> builtins.attrNames
    |> map localDashboard;

  dashboards = map remoteDashboard remote ++ local;
in
runCommandLocal "grafana-dashboards"
  {
    nativeBuildInputs = [
      jq
      yq-go
    ];
    passthru.datasourceUid = datasourceUid;
  }
  ''
    mkdir $out
    ${lib.concatMapStringsSep "\n" (dashboard: ''
      yq -o=json '.' ${dashboard.src} \
        | jq --arg uid '${dashboard.uid}' --arg ds '${datasourceUid}' -e '${normalize}' \
        > $out/${dashboard.uid}.json
    '') dashboards}
  ''
