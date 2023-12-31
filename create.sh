#!/bin/bash
VG_NAME="nfs"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <lv_name> <lv_size>"
    exit 1
fi

LV_NAME=$1
LV_SIZE=$2

# Check if VG exists
if ! vgdisplay "$VG_NAME" &>/dev/null; then
    echo "Error: Volume Group $VG_NAME does not exist."
    exit 1
fi

# Check if LV with the same name exists
if lvdisplay "/dev/$VG_NAME/$LV_NAME" &>/dev/null; then
    echo "Error: LV with name $LV_NAME already exists."
    exit 1
fi
# Check if mount directory exists
MOUNT_DIR="/mnt/$LV_NAME"
if [ -d "$MOUNT_DIR" ]; then
    echo "Error: Mount directory $MOUNT_DIR already exists."
    exit 1
fi

if [ ! -d "$MOUNT_DIR" ]; then
    mkdir -p "$MOUNT_DIR"
fi

# Create the LV
lvcreate -n $LV_NAME -L $LV_SIZE nfs

# Create XFS filesystem
mkfs.xfs -f /dev/nfs/$LV_NAME

# Add entry to /etc/fstab
echo "/dev/nfs/$LV_NAME         $MOUNT_DIR             xfs     defaults        0 0" >> /etc/fstab

# Mount the filesystem
mount -a

# Reload systemd
systemctl daemon-reload

# Add entry to /etc/exports
echo "$MOUNT_DIR/            *(rw,sync,no_root_squash)" >> /etc/exports

# Restart NFS server
systemctl restart nfs-server.service

echo "Setup completed for LV: $LV_NAME with size: $LV_SIZE"
