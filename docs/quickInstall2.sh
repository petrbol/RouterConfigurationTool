#!/bin/bash

apt autoremove -y && \
update-grub && \
wget https://github.com/petrbol/RouterConfigurationTool/raw/main/rctDeb/rct_0.2-1_amd64.deb && \
dpkg -i rct_0.2-1_amd64.deb && \
. /etc/profile.d/rconfig.sh && \
rconfig vpp setup && \
rconfig vpp set MainCore 1 Workers 2 && \
rconfig save -f && \
systemctl enable rctStart && \
systemctl start rctStart
