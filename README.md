## *** Work in progress, deb packages not uploaded at this moment ***
### !!! not for production usage, use at your own risk !!!

## rct - Router Configuration Tool
Router Configuration Tool is simple configuration interface for Vector Path Processing (VPP, fd.io) with limited feature set. This tool is set of systemd services and few app.

### About

- Based on VPP 22.06-rc & linux-cp plugin. Thanks to all people that participate in this project.
- rconfig written in GO, Cobra cli interface, bash-completion
- set of app: `rconfig, rctWatchdog, rctExporter`
- set of systemd services:\
  -`rctBird` # use default bird conf file location\
  -`rctExporter`\
  -`rctExporterCp`\
  -`rctSshd` # use default sshd conf file location  \
  -`rctWatchdog`\
  -`rctVpp`\
  -`rctStart`
- default directory `/etc/rct`, json configuration files
 
### Key features
- Differential configuration VPP using govpp api
- Simplest vpp startup configuration generator (you dont need to configure VPP manually)
- Use separated namespace `controlplane`
- Custom interface name
- IPv4/IPv6 a routing
- Dot1q, QoQ
- VXLAN tunnels
- ABF+ACL policy filtering
- Loopbacks (BVI)
- Bridge Domain and ports configuration (SHG, POP 1)
- L2xconnect
- Exporter for interface statistics based on Prometheus(prometheus.io) with customized interface names, grafana template included
- Watchdog
- Preconfigured systemd services to access via separated namespace("controlplane"): `rctSshd, rctBird, rctExporterCp`

### Configuration example
`rconfig vlan add vlan77 interface enp3s0`# add vlan subinterface\
`rconfig vlan set vlan77 Dot1q 15 ExactMatch true`# set Dot1q main tag\
`rconfig address add 192.168.15.1/24 interface vlan77`# configure address\
`rconfig commit`# perform diff commit\
`rconfig save`

>## Documentation
Configurable examples can be found in [docs](docs)

### rconfig quick example & show
![rconfig example](img/rconfigExample.png?raw=true)

### rctExporter quick look
![rctExporter example](img/rctExporter.png?raw=true)


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
7. reload bash completion file (or logout & login to make bash-completion work again)\
`. /etc/profile.d/rconfig.sh`
8. configure rct. Manual configuration or automatic setup. Setup will try to find network interfaces and offer you to add to add to the rct configuration.\
`rconfig vpp setup` # start setup\
`rconfig vpp set MainCore 0 Workers 3` # configure VPP to use 3 cpu cores for workers and core 0 as main\
`systemctl start rctStart` # if everything is ok, you can enable service after start bellow
9. If `vppctl show interface` show your interfaces and you are still connected to the management port, you can enable rct on startup.`systemctl enable rctStart`
10. Enjoy `rconfig --help` 

### Remove
`apt purge rct* -y && rm -rf /etc/rct && reboot`
