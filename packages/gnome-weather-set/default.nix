{
  bc,
  curl,
  dconf,
  jq,
  writeShellApplication,
}:
writeShellApplication {
  name = "gnome-weather-set";
  runtimeInputs = [
    curl
    dconf
    jq
    bc
  ];
  text = builtins.readFile ./weather.sh;
}
