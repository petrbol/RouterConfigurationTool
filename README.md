## rct - Router Configuration Tool
> #### Free to use, no warranty.

Router Configuration Tool is simple configuration interface for Vector Path Processing (VPP, fd.io) with limited feature set. This tool is set of systemd services and few app. [changelog](rctDeb/changelog.md)

### Latest news
> - Current rct version 0.2-6
> - Current VPP version 23.02
> - Current kea version 2.0.3

### About
- Based on VPP & linux-cp plugin, ISC Kea DHCP, Bird internet routing daemon. Thanks to all people that participate in these projects.
- rconfig written in GO, Cobra cli interface, bash-completion
- set of app: `rconfig, rctWatchdog, rctExporter, rctKeaWatchdog, rctKea6RouteHelper`
- set of systemd services:\
  -`rctBird` # use default bird conf file location\
  -`rctSshd` # use default sshd conf file location  \
  -`rctWatchdog`\
  -`rctVpp`\
  -`rctStart`\
  -`rctKea4`\
  -`rctKea6`\
  -`rctKeaWatchdog`\
  -`rctSnmpd`\
  -`rctSnmpdCp`\
  -`rctKea6RouteHelper`
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
- Det44
- Preconfigured systemd services to access via separated namespace("controlplane"): `rctSshd, rctBird, rctSnmpdCp`
- Preconfigured systemd services for ISC Kea dhcp server: `rctKea4, rctKea6, rctKeaWatchdog`
- Simple source nat on output interface (nat44 + output feature)
- Preconfigured systemd services for snmpd to read VPP traffic (on controlplane)
- Ipv6 prefix delegation route injection helper (from Kea6)

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

### Requirements
* Debian 11
* VPP capable hardware
* Multicore CPU (4 or more cores for better results)
* Hardware with DPDK capable interface
* Minimum 2 ethernet interface (one for VPP and one for management). (note: You can also use the management port in vpp, but you lose management port accessibility.)


>## Installation - Debian 11 
>##### 1. install depends
>```
>apt install bird2 htop traceroute sed curl mc wget sudo libmbedtls12 libmbedx509-0 libmbedcrypto3 libnl-3-200 libnl-route-3-200 libnuma1 python3 libsubunit0 bash-completion liblog4cplus-2.0.5 libmariadb3 libpq5 mariadb-common mysql-common -y
>```
>##### 2. modify grub configuration to set isolcpu for VPP
>```
>mcedit /etc/default/grub
># modify the configuration file
>GRUB_TIMEOUT=1
>GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 isolcpus=1-3 nohz_full=1-3 cpufreq.default_governor=performance intel_iommu=off" 
># run update grub bootloader
>update-grub
>```
>##### 3. download VPP packages
>```
>mkdir rctDebPkg && cd rctDebPkg
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-23.02-release/libvppinfra_23.02-release_amd64.deb
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-23.02-release/vpp-plugin-core_23.02-release_amd64.deb
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-23.02-release/vpp-plugin-dpdk_23.02-release_amd64.deb
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/vpp-23.02-release/vpp_23.02-release_amd64.deb
>```
>#### 4. download KEA dhcp server package
> ```
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/kea-2.0.3/isc-kea-common_2.0.3-isc20220725151155_amd64.deb
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/kea-2.0.3/isc-kea-dhcp4-server_2.0.3-isc20220725151155_amd64.deb
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/kea-2.0.3/isc-kea-dhcp6-server_2.0.3-isc20220725151155_amd64.deb
> ```
>#### 5. install deb package
> ```
> dpkg -i *.deb
> ```
>##### 6. !!! FOR PC Engines APU board only !!! - alternative kernel to fix jitter issue
>```
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-headers-5.15.41_5.15.41-1_amd64.deb
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-image-5.15.41_5.15.41-1_amd64.deb
>dpkg -i linux-headers-5.15.41_5.15.41-1_amd64.deb linux-image-5.15.41_5.15.41-1_amd64.deb
>```
>##### 7. disable VPP service and reboot
>```
>systemctl disable vpp
>reboot
>```
>##### 8. install Router Configuration Tool
>```
>wget -q --show-progress https://github.com/petrbol/RouterConfigurationTool/raw/main/rctDeb/rct_0.2-6_amd64.deb
>dpkg -i rct_0.2-5_amd64.deb
>```
>##### 9. configure rct. Manual configuration or automatic setup. Setup will try to find network interfaces and offer you to add to add to the rct configuration.
>```
>. /etc/profile.d/rconfig.sh # reload bash completion file (or logout & login)
>rconfig vpp setup # start setup
>rconfig vpp set MainCore 1 Workers 2 # configure VPP to use 3 cpu cores for workers and core 0 as main
>rconfig save -f # save additional configuration before start
>rconfig save default -f # save configuration file as default cfg (`rconfig restore default`)
>```
>##### 10. If show your interfaces, you are still connected to the management port, you can enable rct on startup.
>```
># start service
>systemctl start rctStart && sleep 5
>vppctl show interface
># if show your interfaces and you are still connected to the management port, you can enable rct on startup
>systemctl enable rctStart
>```
>##### DONE ... Enjoy


### Remove manuall installed packages
```
apt purge rct -y && rm -rf /etc/rct
apt purge isc-kea* -y
apt purge vpp* -y
reboot
```

### How to upgrade rct
note: !!! install all actual dependents from upper section - point 3. !!!
note: Upgrade via management interface is preferred. If `/etc/rct/startup.cfg` exist, service `rctStart` will be started and enabled after startup.
note: If you need upgrade VPP, use installation instruction above
1. download and install latest rct version: `Installation step 8.`
2. reload bash completion file (or logout & login to make bash-completion work again)\
`. /etc/profile.d/rconfig.sh`

### How to upgrade VPP
note: !!! vpp upgrade recommended via management interface only !!!
1. disable service and reboot router `systemctl disable rctStart && reboot`
2. download new VPP packages and install it with dpkg: `Installation step 3.`
3. enable service and reboot router `systemctl enable rctStart && reboot`

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
`systemctl status rctSshd`\
`systemctl status rctVpp`\
`systemctl status rctKea4`\
`systemctl status rctKea6`\
`systemctl status rctSnmpd`\
`systemctl status rctKea6RouteHelper`

### Known issues
- jitter issue (about 6-10ms) can be observed on the PC Engines APU2/4 board with Debian 11 + original kernel. Custom kernel with ubuntu kernel .config fix this issue.
- Intel X552 sfp+ port without inserted optical module and `AdminUp true` cause `rconfig commit dpdk` failure (no issue for `AdminUp false` or with inserted optical module)