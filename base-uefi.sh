#!/usr/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc

locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=no > /etc/vconsole.conf
echo arch > /etc/hostname
echo root:no | chpasswd

pacman -Syu --noconfirm \
    # Bootloader and EFI tools
    grub efibootmgr \
    \
    # Networking
    networkmanager wpa_supplicant \
    \
    # Core utilities
    dialog base-devel linux-headers vim rsync openssh bash-completion \
    xdg-user-dirs xdg-utils inetutils dnsutils sudo reflector terminus-font \
    \
    # Filesystem and storage tools
    mtools dosfstools ntfs-3g \
    \
    # GVFS and file integration
    gvfs gvfs-smb \
    \
    # Desktop environment
    plasma-meta kde-applications-meta sddm \
    \
    # Audio stack (PipeWire-based)
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
    \
    # Virtualization agents
    spice-vdagent qemu-guest-agent \
    \ 
    # Wayland stack 
    hyprland waybar foot wofi mako swww fish dolphin gtk-engine-murrine gtk-engines

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable acpid

useradd -m harold
echo harold:no | chpasswd

echo "harold ALL=(ALL) ALL" >> /etc/sudoers.d/harold

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

