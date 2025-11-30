#!/bin/bash

# Partition table setup:
# GPT partition table
parted -s /dev/sda mklabel gpt

# 1. EFI System Partition: 1GB
parted -s /dev/sda mkpart ESP fat32 1MiB 1025MiB
parted -s /dev/sda set 1 esp on
# 2. Linux Swap Partition: 4GB
parted -s /dev/sda mkpart swap linux-swap 1025MiB 5121MiB
# 3. Root Partition: Remaining space max 64GB
parted -s /dev/sda mkpart root ext4 5121MiB 100%

# Mount points and formatting:
mkfs.fat -F 32 -n boot /dev/sda1
mkswap -L swap /dev/sda2
mkfs.ext4 -L root /dev/sda3

# Mounting partitions
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

# Install base system
pacstrap -K /mnt base linux linux-firmware

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt 

# Clone and run the installation script
pacman -S --noconfirm git 
git clone https://github.com/1-Erik-1/arch-linux-install-script.git
chmod +x arch-linux-install-script/install.sh
./arch-linux-install-script/install.sh