#!/bin/bash
VG_NAME="nfs"
LV_NAME=$1
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <lv_name>"
    exit 1
fi
read -p "To confirm, please type the LV name ($LV_NAME): " confirm
if [[ "$confirm" != "$LV_NAME" ]]; then
    echo "LV name does not match. Operation aborted."
    exit 1
fi
if ! lvdisplay "/dev/$VG_NAME/$LV_NAME" &>/dev/null; then
    echo "Error: LV with name $LV_NAME does not exist."
    exit 1
fi
umount "/mnt/$LV_NAME"
rm -fr "/mnt/$LV_NAME"
sed -i "\\@/dev/$VG_NAME/$LV_NAME@d" /etc/fstab
lvremove -f "/dev/$VG_NAME/$LV_NAME"
systemctl daemon-reload
sed -i "/\/$LV_NAME\//d" /etc/exports
exportfs -a
echo "Cleanup completed for LV: $LV_NAME"

