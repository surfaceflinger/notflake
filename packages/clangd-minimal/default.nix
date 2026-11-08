{
  lib,
  llvmPackages,
  patchelf,
  removeReferencesTo,
  runCommandLocal,
  stdenv,
  zlib,
  libxml2,
  libffi,
  glibc,
}:
let
  clang = llvmPackages.clang-unwrapped;
  clangLib = clang.lib;
  llvmLib = llvmPackages.llvm.lib;
  libs = lib.makeLibraryPath [
    zlib
    libxml2
    libffi
    glibc
    stdenv.cc.cc.lib
  ];
in
runCommandLocal "clangd-minimal-${clang.version}"
  {
    nativeBuildInputs = [
      patchelf
      removeReferencesTo
    ];
  }
  ''
    mkdir -p $out/bin $out/lib
    cp ${clang}/bin/clangd $out/bin/clangd
    cp -r ${clangLib}/lib/clang $out/lib/clang
    cp -a ${clangLib}/lib/libclang-cpp.so* $out/lib/
    cp -a ${llvmLib}/lib/libLLVM.so* $out/lib/
    chmod -R u+w $out

    patchelf --set-rpath "$out/lib:${libs}" $out/bin/clangd
    for lib in $out/lib/libclang-cpp.so.* $out/lib/libLLVM.so.*; do
      if [ -f "$lib" ] && [ ! -L "$lib" ]; then
        patchelf --set-rpath "\$ORIGIN:${libs}" "$lib"
        remove-references-to -t ${clangLib} "$lib"
        remove-references-to -t ${llvmLib} "$lib"
      fi
    done
    remove-references-to -t ${clangLib} $out/bin/clangd
    remove-references-to -t ${llvmLib} $out/bin/clangd
  ''
