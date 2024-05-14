#!/bin/bash

TYPE="base"
RECIPE="base"
OS_VARIANT="debian12"
ISO_PATH="$HOME/ISOs/debian/debian-12.5.0-amd64-DVD-1.iso"
PRESEED_PATH="."
RAM="4096" # MB
CPUS="4"
DISK_SIZE="32" # GB
DESCRIPTION="used for testing configuration management"

# Example Usage: ./vm-install kde base 20

if [ $# -ge 1 ]; then
    TYPE="$1"
fi

if [ $# -ge 2 ]; then
    RECIPE="$2"
fi

if [ $# -ge 3 ]; then
    DISK_SIZE="$3"
fi

PRESEED_NAME="$TYPE-preseed.cfg"
VM_NAME="debian-$TYPE"

if [ $# -ge 4 ]; then
    VM_NAME="$4"
fi

virt-install \
  --boot uefi \
  --name $VM_NAME \
  --memory $RAM \
  --vcpus $CPUS \
  --disk size=$DISK_SIZE \
  --cdrom $ISO_PATH \
  --os-variant $OS_VARIANT \
  --graphics spice \
  --console pty,target_type=serial \
  --location $ISO_PATH \
  --initrd-inject="$PRESEED_PATH/$PRESEED_NAME" \
  --initrd-inject="$PRESEED_PATH/$RECIPE-recipe.cfg" \
  --extra-args "auto=true preseed/file=/$PRESEED_NAME" \
  --metadata description="$TYPE $DESCRIPTION"
