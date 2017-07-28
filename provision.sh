#!/bin/bash
sudo apt-get update
sudo apt-get install -y git-core build-essential libssl-dev libncurses5-dev
sudo apt-get install -y unzip gawk zlib1g-dev

# Emdebian cross compiler
echo -e "deb http://www.emdebian.org/debian/ squeeze main" | sudo tee -a /etc/apt/sources.list.d/emdebian.list
sudo apt-get update
sudo apt-get install -y emdebian-archive-keyring
sudo apt-get update
sudo apt-get install -y linux-libc-dev-mips-cross libc6-mips-cross libc6-dev-mips-cross binutils-mips-linux-gnu gcc-4.4-mips-linux-gnu g++-4.4-mips-linux-gnu

# To prevent git from complaining
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo touch /var/lib/cloud/instance/locale-check.skip

echo -e "export LC_CTYPE=en_US.UTF-8" | tee -a ~/.profile
echo -e "export LC_ALL=en_US.UTF-8" | tee -a ~/.profile

echo -e "DL Kernel sources"
wget https://www.linux-mips.org/pub/linux/mips/kernel/v3.x/linux-3.10.14.tar.xz
tar xf linux-3.10.14.tar.xz
cp /vagrant/linux-config-3.16/config.mipsel_none_4kc-malta.xz .
unxz config.mipsel_none_4kc-malta.xz
cp config.mipsel_none_4kc-malta ./linux-3.10.14/.config

echo -e "[+] Now you need to SSH into your box and execute the following commands"
echo -e "cd linux-3.10.14"
echo -e "make ARCH=mips CROSS_COMPILE=mips-linux-gnu- menuconfig"
echo -e "make ARCH=mips CROSS_COMPILE=mips-linux-gnu- all -j 4"

echo -e "[+] When done, copy the kernel and initrd in /vagrant and exit..."
echo -e "cp ./usr/initramfs_data.cpio /vagrant/initrd.img-3.10.14-UBNT"
echo -e "cp vmlinux /vagrant/vmlinux-3.10.14-UBNT"
echo "exit"
