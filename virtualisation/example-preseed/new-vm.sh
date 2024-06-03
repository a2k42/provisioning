#!/bin/bash

# This version does NOT use custom recipe

TYPE="minimal"

if [ $# -ge 1 ]; then
    TYPE="$1"
fi

# Define variables
# VM_NAME="debian-12-preseed"       # Customize the VM name
# VM_NAME="debian-12-offline"       # Customize the VM name
VM_NAME="debian-12-$TYPE"       # Customize the VM name
OS_VARIANT="debian12"
ISO_PATH="/home/andy/ISOs/ventoy/debian/debian-12.1.0-amd64-DVD-1.iso"  # Path to the Debian ISO file
PRESEED_NAME="$TYPE-preseed.cfg"
PRESEED_PATH="/home/andy/ISOs/ventoy/preseed"  # Path to the custom preseed file
RAM="4096"               # Customize the RAM size in MB
CPUS="4"                 # Customize the number of CPUs
DISK_SIZE="20"           # Customize the disk size in GB

# Create the VM using virt-install
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
  --extra-args "auto=true preseed/file=/$PRESEED_NAME"

