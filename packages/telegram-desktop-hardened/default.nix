{ graphene-hardened-malloc, telegram-desktop }:
(telegram-desktop.override { withWebkit = false; }).overrideAttrs (old: {
  qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
    "--prefix"
    "LD_PRELOAD"
    ":"
    "${graphene-hardened-malloc}/lib/libhardened_malloc.so"
  ];
})
