#!/bin/bash

VM_NAME="laptop-test"
RAM="4096" # MB
CPUS="4"
DISK_SIZE="8" # GB
ISO_PATH="$HOME/ISOs/debian/debian-12.5.0-amd64-DVD-1.iso"
OS_VARIANT="debian12"
PRESEED_NAME="desktop-preseed.cfg"
RECIPE="desktop-recipe.cfg"
DESCRIPTION="used for testing laptop auto install"

virt-install \
  --boot uefi \
  --name $VM_NAME \
  --memory $RAM \
  --vcpus $CPUS \
  --disk /var/lib/libvirt/images/laptop-test-1.qcow2,size=$DISK_SIZE \
  --disk /var/lib/libvirt/images/laptop-test-2.qcow2,size=1 \
  --cdrom $ISO_PATH \
  --os-variant $OS_VARIANT \
  --graphics spice \
  --console pty,target_type=serial \
  --location $ISO_PATH \
  --initrd-inject="$PRESEED_NAME" \
  --extra-args "auto=true preseed/file=/$PRESEED_NAME" \
  --metadata description="$DESCRIPTION"

#   --initrd-inject="$RECIPE" \