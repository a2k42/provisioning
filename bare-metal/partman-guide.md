# Guide to Debian Auto-Installs with Preseeding



[Securing Debian - Partitioning](https://www.debian.org/doc/manuals/securing-debian-manual/ch03s02.en.html)

```bash
1.6G    /opt
152K    /tmp
14G     /usr/local
144G    /var/
118G    /var/lib/libvirt
1.4G    /var/log/
```

```bash
virsh pool-list

virsh vol-list default
```

## Approaches to Creating a New Install

It used to be difficult injecting your preseed file into the installation process, however, there are 3 different methods that work quite well these days, gone are the days where we had to try and create a custom ISO image with our boot files included

1. Virtual Machine (QEMU/libvirt)
1. Netboot (PXE)
1. Installation media (Ventoy)
1. ~~Authoring an ISO~~

There are, of course, variations on these. You could use VirtualBox or VMWare for virtualisation, iPXE instead of PXE etc but these are the ones I've found most straight forward.

Netbooting is a complex topic requiring its own guide and Ventoy is more appropriate when you are ready to deploy to bare metal. This guide shall focus on auto-installs of virtual machines using QEMU and libvirt as this allows for the most streamlined development cycle when testing your configuration.

## Finding Documentation

TBC

## Setting Up on Debian

Use the ansible roles to install the necessary packages. :construction:

## First Auto-Install

While you can refer to the offical [example preseed](https://www.debian.org/releases/bookworm/example-preseed.txt) file for lots of comments, it is likely overwhelming at first. What you want is to get something working and a minimal example will provide just what you need to get through the installer without being prompted.

`minimal-preseed.cfg`

```cfg
### Localization
d-i debian-installer/locale string en_GB.UTF-8
d-i keyboard-configuration/xkb-keymap select gb

### Network configuration
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string debian-vm0
d-i netcfg/get_domain string vm

### Network console

### Mirror settings

### Account setup
d-i passwd/root-login boolean false

d-i passwd/user-fullname string Test User
d-i passwd/username string test
d-i passwd/user-password-crypted password $y$j9T$TEqbW2zV4e8e9C22CMRju0$.9El0DiUh1noAVjM2SVoj/x0CLXiYK77N0xFB9KgpUC

### Clock and time zone setup
d-i clock-setup/utc boolean true
d-i time/zone string Europe/London
d-i clock-setup/ntp boolean true

### Partitioning
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic

# Confirm partitioning changes
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

### Base system installation
# d-i base-installer/install-recommends boolean false # fails to boot

### Apt setup
d-i apt-setup/use_mirror boolean false
d-i apt-setup/cdrom/set-first boolean false

### Package selection
d-i pkgsel/run_tasksel boolean false
popularity-contest popularity-contest/participate boolean false

### Boot loader installation
d-i grub-installer/only_debian boolean true

### Finishing up the installation
d-i finish-install/reboot_in_progress note

### Preseeding other packages

#### Advanced options
```

The `###` demarkate different sections, though they are just comments, it is useful to group options to better understand what's going on. Some sections don't need any options at this stage.

Create the machine with

```bash
virt-install \
  --boot uefi \
  --name "Guide VM" \
  --memory 1024 \
  --vcpus 1 \
  --disk size=3 \
  --cdrom ~/ISOs/ventoy/debian/debian-12.1.0-amd64-DVD-1.iso \
  --os-variant debian12 \
  --graphics spice \
  --console pty,target_type=serial \
  --location ~/ISOs/ventoy/debian/debian-12.1.0-amd64-DVD-1.iso \
  --initrd-inject ~/ISOs/ventoy/preseed/minimal-preseed.cfg \
  --extra-args "auto=true preseed/file=/minimal-preseed.cfg"
```

### Breakdown of Minimal Preseed File

If that worked for you then we can take a look at what each section does.

:construction:

## Notes

### CD-ROM

It would seem it *should* be possible to leave in cdrom entries as a source and not eject the installation media, however, this doesn't appear to work in qemu

```
# d-i apt-setup/disable-cdrom-entries boolean true
d-i cdrom-detect/eject boolean false
```

### Copying Config Files

```bash
for file in base*; do
    cp "$file" "standard${file#base}"
done
```

### Minimal Desktop

Gnome
: https://www.gnome.org/

Plasma
: A desktop environment made by kde.org

https://www.pragmaticlinux.com/2020/10/install-a-minimal-kde-on-debian-10-buster/

---

# Ventoy Auto-Install Notes

## Docs / Forums

https://www.ventoy.net/en/plugin_autoinstall.html

https://www.mail-archive.com/debian-boot@lists.debian.org/msg177792.html

> I successfully preseed with

```
 d-i netcfg/wireless_show_essids select manual
 d-i netcfg/wireless_essid string Horizon
 d-i netcfg/wireless_security_type select wpa
 d-i netcfg/wireless_wpa string
JYWw2Dx0gy56TJmiP0r8JlHvhs4gm0Q8LgoHuaCGOhOrZAPFLLMBidUFaq7B9Z7
```


## Wireless Config

Easy once you know how!

```ini
# wireless settings
d-i netcfg/wireless_essid         string skyfall
d-i netcfg/wireless_security_type select wpa
d-i netcfg/wireless_wpa           string plaintextpassword
```

- passphrase needs to be plaintext
- setting is `wireless_security_type` and NOT `wireless_key_type` as some docs suggest

## Partman

Although using an external recipe file works fine with QEMU, it was not picked up with Ventoy.

Note the difference between `expert_recipe_file` and `expert_recipe` when inlining.

```ini
#d-i partman-auto/expert_recipe_file string /laptop-recipe.cfg
 d-i partman-auto/expert_recipe string     \
    laptop-recipe ::                      \
        512 4096 512 fat32                \
            $iflabel{ gpt }               \
            $reusemethod{ }               \
            method{ efi }                 \
            format{ } .                   \
        512 4096 512 ext4                 \
            $defaultignore{ }             \
            method{ format }              \
            format{ }                     \
            use_filesystem{ }             \
            filesystem{ ext4 }            \
            mountpoint{ /boot } .         \
        100% 200% 200% linux-swap         \
            $lvmok{ }                     \
            $reusemethod{ }               \
            lv_name{ swap }               \
            method{ swap }                \
            format{ } .                   \
        2048 4096 61440 ext4              \
            $lvmok{ }                     \
            lv_name{ root }               \
            method{ format }              \
            format{ }                     \
            use_filesystem{ }             \
            filesystem{ ext4 }            \
            mountpoint{ / } .
```