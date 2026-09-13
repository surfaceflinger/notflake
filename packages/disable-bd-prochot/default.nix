{
  kmod,
  msr-tools,
  writeShellApplication,
}:
writeShellApplication {
  name = "disable-bd-prochot";

  runtimeInputs = [
    kmod
    msr-tools
  ];

  text = ''
    for dev in /dev/cpu/[0-9]*; do
      cpu=''${dev#/dev/cpu/}
      hi=$(( 0x$(rdmsr -p "$cpu" -f 63:32 0x1FC) ))
      lo=$(( 0x$(rdmsr -p "$cpu" -f 31:0 0x1FC) ))

      if [ "$(( lo & 1 ))" -eq 1 ]; then
        old_hi=$hi
        old_lo=$lo
        lo=$(( lo & 0xFFFFFFFE ))
        wrmsr -p "$cpu" 0x1FC "$(printf '0x%08x%08x' "$hi" "$lo")"
        printf '<4>bd-prochot: re-enabled on CPU %s (MSR 0x1FC 0x%08x%08x -> 0x%08x%08x), cleared\n' \
          "$cpu" "$old_hi" "$old_lo" "$hi" "$lo" >&2
        # verify the write took
        [ "$(rdmsr -p "$cpu" -f 0:0 0x1FC)" = 0 ]
      fi
    done
  '';
}
