{ curl, writeShellApplication }:
writeShellApplication {
  name = "gnome-gravatar";
  runtimeInputs = [ curl ];
  text = builtins.readFile ./gravatar.sh;
}
