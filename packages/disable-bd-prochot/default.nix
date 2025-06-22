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
    # swap the last nibble of msr 0x1fc to e
    set -xeuo pipefail
    modprobe msr
    current=$(rdmsr 0x1FC)
    zero=$((0x$current & 0xFFFFFFF0))
    final=$((zero | 0x0000000E))
    wrmsr 0x1FC $final
  '';
}
