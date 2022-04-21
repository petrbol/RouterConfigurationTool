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
2. modify /etc/default/grub to set isolcpu for VPP\
```GRUB_CMDLINE_LINUX="isolcpus=1,2,3"```
3. install VPP depends\
`apt install bird2 sed libmbedtls12 libmbedx509-0 libmbedcrypto3 libnl-3-200 libnl-route-3-200 libnuma1 python3 libsubunit0 bash-completion -y`
4. install VPP from prepaired .deb packages\
`dpkg -i vpp*.deb`
5. update grub, disable VPP service and perform reboot before install rct .deb package\
`update-grub && systemctl stop vpp && systemctl disable vpp && reboot`
6. install rct package\
`dpkg -i rct*.deb`
7. configure rct. Manual configuration or automatic setup. Setup will try to find network interfaces and offer you to add to add to the rct configuration.\
`rconfig vpp setup` # start setup\
`rconfig vpp set Workers 3` # configure VPP to use 3 cpu cores for workers\
`rconfig vpp set MainCore 0` # can be skipped, default value is 0\
`systemctl start rctStart` # if everything is ok, you can enable service after start bellow

If `vppctl show intefaces` show your interfaces and you are still connected to the management port, you can enable rct on startup.\
`systemctl enable rctStart`
