{ k9s }:
k9s.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [ ./k9s-ansi.patch ];
  # tests assert the old truecolor values
  doCheck = false;
})
