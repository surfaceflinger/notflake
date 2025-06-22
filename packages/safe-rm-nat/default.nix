{
  safe-rm,
  symlinkJoin,
}:
let
  safe-rm' = safe-rm.overrideAttrs (old: {
    patches = old.patches ++ [
      ./paths.patch
    ];
  });
in
symlinkJoin {
  name = "safe-rm-nat";
  inherit (safe-rm') version;
  paths = [ safe-rm' ];
  postBuild = ''
    mkdir -p $out/bin
    ln -s ${safe-rm'}/bin/safe-rm $out/bin/rm
  '';
}
