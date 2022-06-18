#!/bin/bash

sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/g' /etc/default/grub && \
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 isolcpus=1-3 nohz_full=1-3 cpufreq.default_governor=performance"/g' /etc/default/grub && \
apt install bird2 htop sed curl wget sudo libmbedtls12 libmbedx509-0 libmbedcrypto3 libnl-3-200 libnl-route-3-200 libnuma1 python3 libsubunit0 bash-completion -y && \
curl -s https://packagecloud.io/install/repositories/fdio/2206/script.deb.sh | sudo bash && \
apt install vpp vpp-plugin-core vpp-plugin-dpdk -y && \
wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-headers-5.15.41_5.15.41-1_amd64.deb && \
wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-image-5.15.41_5.15.41-1_amd64.deb && \
dpkg -i linux-headers-5.15.41_5.15.41-1_amd64.deb linux-image-5.15.41_5.15.41-1_amd64.deb && \
update-grub && systemctl stop vpp && systemctl disable vpp && reboot
