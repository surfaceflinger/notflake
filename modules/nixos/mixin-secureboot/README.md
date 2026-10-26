# Secure Boot

## Setup

1. Disable Secure Boot in firmware.
2. `nilla os switch` — creates `/var/lib/sbctl/keys` if missing and signs Limine.
3. Reboot to firmware, clear Secure Boot keys or enable Setup Mode.
4. `sudo sbctl enroll-keys --microsoft --firmware-builtin`
5. Reboot and enable Secure Boot.
6. `sudo sbctl status` should report Secure Boot enabled. `sudo sbctl verify` lists signed files.
