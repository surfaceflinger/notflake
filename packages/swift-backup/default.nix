{
  writeShellApplication,
  mbuffer,
  rage,
  swiftclient,
}:
writeShellApplication {
  name = "swift-backup";

  runtimeInputs = [
    mbuffer
    rage
    swiftclient
  ];

  text = ''
    FILENAME="$(date +'%Y-%m-%d_%H-%M-%S').age"
    mbuffer -m 512M | rage -R ${../../keys/nat.full.keys} -o - | mbuffer -m 512M | swift upload --segment-size 1G -H "X-Delete-After: $EXPIRY" --object-name "$FILENAME" "$BUCKET" -
  '';
}
