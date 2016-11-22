#!/bin/bash
#
# Feng Jin 2016/10/18
# Create a bootable disk image with grub2
# Copy kernel img file to disk image
#

# Check current user, only root user allowed to run this script
if (( $(id -u) != 0 ))
then
    echo "ERROR: This script mush be run as root" 1>&2
    exit 1
fi

# grub-install utility
GRUB_UTILITY=$PWD/grub-2.00/install/sbin/grub-install
DEFAULT_GRUB_UTILITY=false
# Name of disk image
IMAGE=disk
# Find loop device to setup disk image
LOOPDEV=$(losetup -f)
# Mount point 
MOUNT_POINT=/mnt/disk_img_mk
# Device map of loop device
DEV_MAP=$(echo ${LOOPDEV} | cut -d'/' -f 3)
# Init ram disk file
INITRD=initrd.img
# vmlinuz file
VMLINUZ=vmlinuz
# kernel source code version
KER_VER=2.6.32.69
# boot directory
BOOT=/boot

# Delete disk image if exists
if [[ -f ${IMAGE}.img ]]
then
    rm -f ${IMAGE}.img
fi

# Create disk image
# sector size: 512
# count: 28800
dd if=/dev/zero of=${IMAGE}.img bs=512 count=28800

# Setup loop back device using created image
losetup ${LOOPDEV} ${IMAGE}.img

# Create msdos partition table on the image
parted ${LOOPDEV} mklabel msdos

# Add a partition from 64th sectors to end of the image
parted ${LOOPDEV} mkpart primary ext2 32k 100% -a min

# Set the bootable bit of the first partition
parted ${LOOPDEV} set 1 boot on

# Failed when using compiled grub-install utility
if (( ${DEFAULT_GRUB_UTILITY} ))
then
echo "ERROR: It's impossible to run here to add partition to kernel!" 1>&2
# Add new partition to kernel, new block device named 
# Install kpartx with command: "apt-get install kpartx" if not install
kpartx -a ${LOOPDEV}

# Format new partition as ext2
mke2fs /dev/mapper/${DEV_MAP}p1
fi

# Setuo loop back device from sector 64
NEW_LOOPDEV=$(losetup -f)
losetup -o $((63*512)) ${NEW_LOOPDEV} ${IMAGE}.img

# Format the loop back device with filesyste type ext2
mke2fs ${NEW_LOOPDEV}

# Create mount point folder, first remove the mount point if exist
if [[ ! -d ${MOUNT_POINT} ]]
then
    mkdir -p ${MOUNT_POINT}
fi

if (( ${DEFAULT_GRUB_UTILITY} ))
then
echo "ERROR: It's impossible to run here to mount mapped partition!" 1>&2
# Mount new partition to mount point
mount /dev/mapper/${DEV_MAP}p1 ${MOUNT_POINT}
fi
mount ${NEW_LOOPDEV} ${MOUNT_POINT}

# Create grub directory
mkdir -p ${MOUNT_POINT}/boot/grub

# Install grub2
${GRUB_UTILITY} --no-floppy --boot-directory=${MOUNT_POINT}/boot --modules="ext2 part_msdos" ${LOOPDEV}

# Copy compiled kernel image to disk
# Check vmlinuz and initrd exist
if [[ -f ${BOOT}/${VMLINUZ}-${KER_VER} && -f ${BOOT}/${INITRD}-${KER_VER} ]]
then
    cp ${BOOT}/${VMLINUZ}-${KER_VER} ${BOOT}/${INITRD}-${KER_VER} ${MOUNT_POINT}/boot
    cat > ${MOUNT_POINT}/boot/grub/grub.cfg <<- 'EOF'
set timeout=10
set default=0

menuentry 'linux OS' {
    set root=(hd0,1)
    linux /boot/vmlinuz-2.6.32.69 root=/dev/sda
    initrd /boot/initrd.img-2.6.32.69
}
EOF
else
echo "ERROR: Check if vmlinuz and initrd exist" 1>&2
fi

# Unmount the filesystem, remove partition and delete loopback device
umount ${MOUNT_POINT}
if (( ${DEFAULT_GRUB_UTILITY} ))
then
kpartx -d ${LOOPDEV}
fi
losetup -d ${NEW_LOOPDEV}
losetup -d ${LOOPDEV}
