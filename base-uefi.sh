#!/usr/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=no" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd

pacman -S grub efibootmgr networkmanager wpa_supplicant dialog base-devel linux-headers neofetch vim rsync openssh bash-completion xdg-user-dirs xdg-utils gvfs gvfs-smb inetutils dnsutils sudo plasma-meta kde-applications-meta sddm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber spice-vdagent qemu-guest-agent mtools dosfstools ntfs-3g reflector terminus-font

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m harold
echo harold:password | chpasswd
usermod -aG libvirt harold

echo "harold ALL=(ALL) ALL" >> /etc/sudoers.d/harold

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

