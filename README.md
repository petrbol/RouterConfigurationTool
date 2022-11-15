## rct - Router Configuration Tool
> #### * not recommended for production usage. Use at your own risk.

Router Configuration Tool is simple configuration interface for Vector Path Processing (VPP, fd.io) with limited feature set. This tool is set of systemd services and few app. [changelog](rctDeb/changelog.md)

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
  -`rctStart`\
  -`rctKea4`\
  -`rctKea6`\
  -`rctKeaWatchdog`\
  -`rctSnmpd`
- default directory `/etc/rct`, json configuration files
 
### Key features
- Differential configuration VPP using govpp api
- Simplest vpp startup configuration generator (you dont need to configure VPP manually)
- Use separated namespace `controlplane`
- Custom interface name
- IPv4/IPv6 a routing
- Dot1q, QinQ
- VXLAN tunnels
- ABF+ACL policy filtering
- Loopbacks (BVI)
- Bridge Domain and ports configuration (SHG, POP 1)
- L2xconnect
- Exporter for interface statistics based on Prometheus(prometheus.io) with customized interface names, grafana template included
- Watchdog
- Preconfigured systemd services to access via separated namespace("controlplane"): `rctSshd, rctBird, rctExporterCp`
- Preconfigured systemd services for ISC Kea dhcp server: `rctKea4, rctKea6, rctKeaWatchdog`
- Static ipv4/ipv6 routes (netlink to controlplane)
- Simple source nat on output interface (nat44 + output feature)
- Preconfigured systemd services for snmpd (on controlplane)

### Configuration example
`rconfig vlan add vlan77 interface enp3s0`# add vlan subinterface\
`rconfig vlan set vlan77 Dot1q 15 ExactMatch true AdminUp true`# set Dot1q main tag\
`rconfig address add 192.168.15.1/24 interface vlan77`# configure address\
`rconfig commit`# perform diff commit\
`rconfig save`

### Documentation
Topology [example1](docs/example1.md) (routing, vlan, loopback, bridge domain, abf)\
Topology [example2](docs/example2.md) (routing, loopback, vxlan, l2xconnect)\
Configuration and installation examples can be found in [docs](docs)

### rconfig quick example & show
![rconfig example](img/rconfigExample.png?raw=true)

### rctExporter quick look
![rctExporter example](img/rctExporter.png?raw=true)

### Requirements
* Debian 11
* VPP capable hardware
* Multicore CPU (4 or more cores for better results)
* Hardware with DPDK capable interface
* Minimum 2 ethernet interface (one for VPP and one for management). (note: You can also use the management port in vpp, but you lose management port accessibility.)


>## Installation
>##### 1. install Debian 11 
>##### 2. modify `/etc/default/grub` to set isolcpu for VPP
>```
>GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 isolcpus=1-3 nohz_full=1-3 cpufreq.default_governor=performance intel_iommu=off"
>```
>##### 3. install depends
>```
>apt install bird2 snmpd htop traceroute sed curl wget sudo libmbedtls12 libmbedx509-0 libmbedcrypto3 libnl-3-200 libnl-route-3-200 libnuma1 python3 libsubunit0 bash-completion -y
>```
>##### 4. download and install packages
>```
>mkdir rctDebPkg && cd rctDebPkg
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-22.10-patchedRA/libvppinfra_22.10-release_amd64.deb
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-22.10-patchedRA/vpp-plugin-core_22.10-release_amd64.deb
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-22.10-patchedRA/vpp-plugin-dpdk_22.10-release_amd64.deb
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-22.10-patchedRA/vpp_22.10-release_amd64.deb
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kea-2.0.3/isc-kea-dhcp4-server_2.0.3-isc20220725151155_amd64.deb
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kea-2.0.3/isc-kea-dhcp6-server_2.0.3-isc20220725151155_amd64.deb
>dpkg -i *.deb
>```
>##### 5. !!! FOR PC Engines APU board only !!! - alternative kernel to fix jitter issue
>```
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-headers-5.15.41_5.15.41-1_amd64.deb
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-image-5.15.41_5.15.41-1_amd64.deb
>dpkg -i linux-headers-5.15.41_5.15.41-1_amd64.deb linux-image-5.15.41_5.15.41-1_amd64.deb
>```
>##### 6. update grub, disable services and reboot
>```
>update-grub
>systemctl disable vpp
>systemctl disable isc-kea-dhcp4-server
>systemctl disable isc-kea-dhcp6-server
>reboot
>```
>##### 7. install Router Configuration Tool
>```
>wget https://github.com/petrbol/RouterConfigurationTool/raw/main/rctDeb/rct_0.2-2_amd64.deb
>dpkg -i rct_0.2-2_amd64.deb
>```
>##### 8. reload bash completion file (or logout & login to make bash-completion work again)
>```
>. /etc/profile.d/rconfig.sh
>```
>##### 9. configure rct. Manual configuration or automatic setup. Setup will try to find network interfaces and offer you to add to add to the rct configuration.
>```
>rconfig vpp setup # start setup
>rconfig vpp set MainCore 1 Workers 2 # configure VPP to use 3 cpu cores for workers and core 0 as main
>rconfig save -f # save additional configuration before start
>rconfig save default # save configuration file as default cfg (`rconfig restore default`)
>```
>##### 10. start rctStart - if configuration file exist, rct will start automatically
>```
>systemctl start rctStart
>```
>##### 11. If `vppctl show interface` show your interfaces, if you are still connected to the management port, you can enable rct on startup.\
>```
>systemctl enable rctStart```
>##### 12. Enjoy `rconfig --help` 


### Remove
`apt purge rct -y && rm -rf /etc/rct && reboot`

### How to upgrade
note: !!! install all actual dependents from upper section - point 3. !!!
note: Upgrade via management interface is preferred. If `/etc/rct/startup.cfg` exist, service `rctStart` will be started and enabled after startup.
1. download latest rct version `wget https://github.com/petrbol/RouterConfigurationTool/raw/main/rctDeb/rct_0.2-2_amd64.deb`
2. install `dpkg -i rct_0.2-2_amd64.deb`
3. reload bash completion file (or logout & login to make bash-completion work again)\
`. /etc/profile.d/rconfig.sh`

### Useful commands
`rconfig save` # save running configuration to startup\
`rconfig commit` # apply configuration, no save\
`rconfig restore default` # restore configuration from default(created by `rconfig vpp setup`) to running without commit\
`rconfig commit dpdk` # perform full vpp & controlplane restart\
`rconfig address show`\
`rconfig ping` # ping command alias, executed in controlplane\
`rconfig ip` # ip command alias, executed in controlplane\
`rconfig traceroute` # traceroute command alias, executed in controlplane\
`birdc` # interactive bird debug cli\
`birdc c` # reload bird configuration\
`vppctl` # interactive vpp debug cli\
`ip netns exec controlplane bash` # jump from management namespace to controlplane namespace (useful for debug)\
`systemctl status rctBird`\
`systemctl status rctExporter`\
`systemctl status rctExporterCp`\
`systemctl status rctSshd`\
`systemctl status rctVpp`\
`systemctl status rctKea4`\
`systemctl status rctKea6`\
`systemctl status rctSnmpd`

### Known issues
- jitter issue (about 6-10ms) can be observed on the PC Engines APU2/4 board with Debian 11 + original kernel. Custom kernel with ubuntu kernel .config fix this issue.
- Intel X552 sfp+ port without inserted optical module and `AdminUp true` cause `rconfig commit dpdk` failure (no issue for `AdminUp false` or with inserted optical module)