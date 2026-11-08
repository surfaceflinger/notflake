{
  libgweather,
  python3Packages,
  writers,
}:
writers.writePython3Bin "gnome-weather-set" {
  libraries = [ python3Packages.pygobject3 ];
  # the project formats python with ruff (88 columns)
  flakeIgnore = [ "E501" ];
  makeWrapperArgs = [
    "--prefix GI_TYPELIB_PATH : ${libgweather}/lib/girepository-1.0"
    "--prefix LD_LIBRARY_PATH : ${libgweather}/lib"
  ];
} (builtins.readFile ./gnome-weather-set.py)
