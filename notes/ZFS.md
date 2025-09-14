## create encrypted pool with stripe:

```
zpool create -f \
  -o ashift=13 \
  -O acltype=posixacl \
  -O atime=off \
  -O checksum=blake3 \
  -O compression=zstd \
  -O devices=off \
  -O dnodesize=auto \
  -O normalization=formD \
  -O utf8only=on \
  -O xattr=sa \
  \
  -O encryption=aes-256-gcm \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  \
  -R /mnt \
  -O mountpoint=none \
  blahaj \
  /dev/disk/by-id/ata-CT250MX500SSD1_2141E5D95F83-part2 /dev/disk/by-id/ata-CT250MX500SSD1_2141E5D95F96
```

Once zpool is imported, every dataset that's marked as canmount=on and has set mountpoint will be mounted automatically. `-R /mnt` will prefix every dataset mountpoint with `/mnt` (temporarily, for OS installation only).

Every `-O` attribute passed to `zpool create` is actually some `-o` setting for dataset. Setting them to zpool will make it so every dataset will have these by default. This includes encryption - zpool isn't encrypted, datasets are. (yeah, this leaks zpool structure)

## create datasets.

```
zfs create -o canmount=off -o mountpoint=/ blahaj/NixOS
zfs create -o canmount=off                 blahaj/NixOS/etc
zfs create -o canmount=on                  blahaj/NixOS/etc/NetworkManager
zfs create -o canmount=on                  blahaj/NixOS/etc/ssh
zfs create -o canmount=on                  blahaj/NixOS/home
zfs create -o canmount=on                  blahaj/NixOS/nix
zfs create -o canmount=off                 blahaj/NixOS/var
zfs create -o canmount=on                  blahaj/NixOS/var/cache
zfs create -o canmount=on                  blahaj/NixOS/var/lib
zfs create -o canmount=on                  blahaj/NixOS/var/log
zfs create -o canmount=on                  blahaj/NixOS/vol/Games
```

Why datasets like `blahaj/NixOS` have mountpoints but `canmount` is set to `off`? - Well, you don't have to create these datasets at all. It'll just work like a `container` for eg. `blahaj/NixOS/etc` so `zfs show` can show sum of used space and "slave" datasets will inherit parent `-o` options.

If you want to eg. create just `blahaj/NixOS/etc/nixos` without "container" datasets then you will have to setup its mountpoint explicitly.

In my example it'll just inherit `mountpoint=/` and because it's a "slave" dataset - it'll transparently append `/etc` to the end.

## example result

`# zfs list`

```
NAME                           USED  AVAIL     REFER  MOUNTPOINT
blahaj                         152G   296G      192K  none
blahaj/Games                   126G   296G      126G  /vol/Games
blahaj/NixOS                  25.9G   296G      192K  /
blahaj/NixOS/etc              5.16M   296G      192K  /etc
blahaj/NixOS/etc/nixos        4.97M   296G     4.97M  /etc/nixos
blahaj/NixOS/home             14.8G   296G     14.8G  /home
blahaj/NixOS/nix              9.08G   296G     9.08G  /nix
blahaj/NixOS/persist          2.02M   296G     2.02M  /persist
blahaj/NixOS/var              2.04G   296G      192K  /var
blahaj/NixOS/var/lib          2.04G   296G     2.04G  /var/lib
blahaj/NixOS/var/log           284K   296G      284K  /var/log
```
