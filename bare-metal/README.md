# Preseed Files

[**entek.org.uk**](https://blog.entek.org.uk/notes/2023/08/22/automated-debian-install.html) <-- read this

https://www.debian.org/releases/bookworm/amd64/apbs04.en.html

https://salsa.debian.org/installer-team/debian-installer/-/blob/master/doc/devel/partman-auto-recipe.txt

## Minimal

This is the most basic configuration which gets through the auto-installer without prompting for any answers.

Similarly, the script to run it with qemu has also been kept simple.

```bash
./minimal-install.sh
```

```bash
virt-viewer --connect qemu:///system --wait minimal
```

> Note that some of the other preseed files have template fields `{{ value }}` that need replacing with real values.

## Passwords / Passphrases

Passwords should be hashed, but for testing use:

- username: `test`
- password: `secret`
- cryptsetup: `super-secret`

To remove a previous known host

```bash
ssh-keygen -f ~/.ssh/known_hosts -R debian-kde.local
```

## User Scripts

Utility scripts a user can go in `~/.local/bin` or for all users `/usr/local/bin`

## Partitioning

At current, it seems the debian install insists upon having a `/boot` directory even though `/boot/efi` should be ok.

Pop_OS uses `systemd-boot` instead of grub and that apparently works better. However, it is not trivial to change the bootloader that debian uses.

Debian's auto-installer also seems to make it difficult to create crypto partitions without having an lvm group inside it.

Not only is preseeding and partman poorly documented, but it lacks flexibility to setup the system the way you want.

### Desktop Usage

After clearing out docker, qemu, and games, desktop usage was

```bash
451G    total
394G    ./home
30G     ./var
25G     ./usr
3.0G    ./recovery
740M    ./boot
153M    ./opt
72M     ./root
34M     ./etc
4.0M    ./run
```

[Recommended](https://www.debian.org/releases/stable/i386/apcs03.en.html) volumes

`/`
`/var` - 200GB
`/tmp` - 10GB
`/home` - ...
`/pool`

Additionally consider `/usr/local`.

```bash
lsblk --output NAME,FSTYPE,FSVER,LABEL,FSSIZE,FSAVAIL,FSUSED,MOUNTPOINTS
```

Default for POP_OS

```bash
NAME            FSTYPE      FSVER    LABEL     FSSIZE FSAVAIL FSUSED MOUNTPOINTS
zram0                                                                [SWAP]
nvme0n1
├─nvme0n1p1     vfat        FAT32               1020M  605.3M 414.6M /boot/efi
├─nvme0n1p2     vfat        FAT32                  4G    1.1G   2.9G /recovery
├─nvme0n1p3     crypto_LUKS 2
│ └─cryptdata   LVM2_member LVM2 001
│   └─data-root ext4        1.0                  1.8T  786.7G 986.2G /
└─nvme0n1p4     swap        1
  └─cryptswap   swap        1        cryptswap                       [SWAP]
```
