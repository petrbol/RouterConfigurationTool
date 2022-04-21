## rct - Router Configuration Tool

Router Configuration Tool(rct) is simple configuration interface for Vector Path Processing (VPP, fd.io) with limited feature set. This tool is set of systemd services and few app.

### !!! not for production usage !!!

### Annotations
- Based on VPP 22.06-rc & linux-cp plugin. Thanks to all people that participate in this project.
- rconfig written in GO, Cobra cli interface, bash-completion
- set of app: `rconfig, rctWatchdog, rctExporter`
- set of systemd services: `rctBird, rctExporter, rctExporterCp, rctSshd, rctWatchdog, rctVpp, rctStart`
- default directory `/etc/rct`, json configuration files
 
### Key features
- Differential configuration VPP using govpp api
- Simplest vpp startup configuration generator (you dont need to configure VPP manually)
- Use separated namespace `controlplane`
- Custom interface name
- IPv4/IPv6 a routing
- Dot1q, QoQ
- VXLAN tunnels
- Loopbacks (BVI)
- Bridge Domain and ports configuration (SHG, POP 1)
- L2xconnect
- Exporter for interface statistics based on Prometheus(prometheus.io) with customized interface names
- Watchdog
- Preconfigured systemd services to access via separated namespace("controlplane"): `rctSshd, rctBird, rctExporterCp`

### Configuration example
`rconfig vlan add vlan77 interface enp3s0`# add vlan subinterface\
`rconfig vlan set vlan77 Dot1q 15 ExactMatch true`# set Dot1q main tag\
`rconfig address add 192.168.15.1/24 interface vlan77`# configure address\
`rconfig commit`# perform diff commit\
`rconfig save`

### rctExporter quick look


### Requirements
* Debian 11
* VPP capable hardware
* Multicore CPU (4 or more cores for better results)
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
7. logout & login to make bash-completion work correctly
8. configure rct. Manual configuration or automatic setup. Setup will try to find network interfaces and offer you to add to add to the rct configuration.\
`rconfig vpp setup` # start setup\
`rconfig vpp set Workers 3` # configure VPP to use 3 cpu cores for workers\
`rconfig vpp set MainCore 0` # can be skipped, default value is 0\
`systemctl start rctStart` # if everything is ok, you can enable service after start bellow

If `vppctl show intefaces` show your interfaces and you are still connected to the management port, you can enable rct on startup.\
`systemctl enable rctStart`

### Remove
`apt purge rct* -y && rm -rf /etc/rct && reboot`
