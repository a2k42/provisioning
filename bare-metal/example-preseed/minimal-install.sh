#!/bin/bash

ISO_PATH="$HOME/ISOs/debian/debian-12.5.0-amd64-DVD-1.iso"

virt-install \
  --boot uefi \
  --name minimal \
  --memory 4096 \
  --vcpus 2 \
  --disk size=5 \
  --cdrom $ISO_PATH \
  --os-variant debian12 \
  --graphics spice \
  --console pty,target_type=serial \
  --location $ISO_PATH \
  --initrd-inject="./minimal-preseed.cfg" \
  --extra-args "auto=true preseed/file=/minimal-preseed.cfg" \
  --metadata description="Minimal auto install"
