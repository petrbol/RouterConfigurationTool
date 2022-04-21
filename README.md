## rct - Router Configuration Tool

Router Configuration Tool(rct) is simple configuration interface for Vector Path Processing (VPP, fd.io) with limited feature set. This tool is set of few systemd services and few app.

### !!! not for production usage !!!


### Requirements:
* Debian 11
* VPP capable hardware
* Multicore CPU (4 or more cores for best results)
* Hardware with DPDK capable interface
* Minimum 2 ethernet interface (one for VPP and one for management)

### Installation
1. install Debian 11 
2. modify /etc/default/grub to set isolcpu for VPP
```GRUB_CMDLINE_LINUX="isolcpus=1,2,3"```
3. execute: `update-grub && reboot`
4. install VPP depends
`apt install bird2 sed libmbedtls12 libmbedx509-0 libmbedcrypto3 libnl-3-200 libnl-route-3-200 libnuma1 python3 libsubunit0 bash-completion -y`
5. install VPP from prepaired .deb packages
`dpkg -i vpp*.deb`
6. disable VPP service and perform reboot before install rct .deb package
`systemctl stop vpp && systemctl disable vpp && reboot`