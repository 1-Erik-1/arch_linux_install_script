#!/usr/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=no" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   arch" >> /etc/hosts
echo root:no | chpasswd

pacman -Syu --noconfirm \
    grub efibootmgr \
    networkmanager wpa_supplicant \
    dialog base-devel linux-headers vim rsync openssh bash-completion \
    xdg-user-dirs xdg-utils inetutils dnsutils sudo reflector terminus-font \
    mtools dosfstools ntfs-3g \
    gvfs gvfs-smb \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
    spice-vdagent qemu-guest-agent \
    hyprland waybar foot wofi mako swww fish dolphin greetd tlp xdg-desktop-portal-wlr pavucontrol \
    adwaita-gtk3 adwaita-gtk4 qt5ct qt6ct adwaita-qt papirus-icon-theme \
    noto-fonts ttf-dejavu ttf-ubuntu-font-family

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable greetd
systemctl enable tlp

useradd -m harold
echo harold:no | chpasswd

echo "harold ALL=(ALL) ALL" >> /etc/sudoers.d/harold

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

