#!/bin/bash
VG_NAME="nfs"
ACL="192.168.100.0/24"
LV_NAME=$1
LV_SIZE=$2
MOUNT_DIR="/mnt/$LV_NAME"
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <lv_name> <lv_size>"
    exit 1
fi
if ! vgdisplay "$VG_NAME" &>/dev/null; then
    echo "Error: Volume Group $VG_NAME does not exist."
    exit 1
fi
if lvdisplay "/dev/$VG_NAME/$LV_NAME" &>/dev/null; then
    echo "Error: LV with name $LV_NAME already exists."
    exit 1
fi
if [ -d "$MOUNT_DIR" ]; then
    echo "Error: Mount directory $MOUNT_DIR already exists."
    exit 1
fi
if [ ! -d "$MOUNT_DIR" ]; then
    mkdir -p "$MOUNT_DIR"
fi
lvcreate -n $LV_NAME -L $LV_SIZE $VG_NAME
mkfs.xfs -f /dev/$VG_NAME/$LV_NAME
echo "/dev/$VG_NAME/$LV_NAME         $MOUNT_DIR             xfs     defaults        0 0" >> /etc/fstab
mount -a
systemctl daemon-reload
echo "$MOUNT_DIR/            $ACL(rw,sync,no_root_squash)" >> /etc/exports
exportfs -a
echo "Setup completed for LV: $LV_NAME with size: $LV_SIZE"
