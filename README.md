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
  -`rctKeaWatchdog`
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

### Configuration example
`rconfig vlan add vlan77 interface enp3s0`# add vlan subinterface\
`rconfig vlan set vlan77 Dot1q 15 ExactMatch true`# set Dot1q main tag\
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

### Installation
1. install Debian 11 
2. modify `/etc/default/grub` to set isolcpu for VPP\
```GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 isolcpus=1-3 nohz_full=1-3 cpufreq.default_governor=performance"```
3. install VPP depends\
`apt install bird2 htop sed curl wget sudo libmbedtls12 libmbedx509-0 libmbedcrypto3 libnl-3-200 libnl-route-3-200 libnuma1 python3 libsubunit0 bash-completion -y`
4. add VPP master `https://packagecloud.io/fdio/2206` repository\
`curl -s https://packagecloud.io/install/repositories/fdio/2206/script.deb.sh | sudo bash`
5. install packages\
`apt install vpp vpp-plugin-core vpp-plugin-dpdk -y`
6. install alternative kernel for PC Engines APU board only\
`wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-headers-5.15.41_5.15.41-1_amd64.deb` # download kernel headers\
`wget https://github.com/petrbol/RouterConfigurationTool/raw/main/kernel/5.15.41/linux-image-5.15.41_5.15.41-1_amd64.deb` # download kernel image\
`dpkg -i linux-headers-5.15.41_5.15.41-1_amd64.deb linux-image-5.15.41_5.15.41-1_amd64.deb` # install kernel
7. update grub, disable VPP service and perform reboot before install rct .deb package\
`update-grub && systemctl stop vpp && systemctl disable vpp && reboot`
8. install Router Configuration Tool\
`wget https://github.com/petrbol/RouterConfigurationTool/raw/main/rctDeb/rct_0.2-1_amd64.deb` # download latest rct package\
`dpkg -i rct_0.2-1_amd64.deb` # install package
9. reload bash completion file (or logout & login to make bash-completion work again)\
`. /etc/profile.d/rconfig.sh`
10. configure rct. Manual configuration or automatic setup. Setup will try to find network interfaces and offer you to add to add to the rct configuration.\
`rconfig vpp setup` # start setup\
`rconfig vpp set MainCore 1 Workers 2` # configure VPP to use 3 cpu cores for workers and core 0 as main\
`rconfig save -f` # save additional configuration before start.
11. `systemctl start rctStart` # if configuration file exist, rct will start automatically
12. If `vppctl show interface` show your interfaces, if you are still connected to the management port, you can enable rct on startup.\
`systemctl enable rctStart`
13. Enjoy `rconfig --help` 
#### * quick installation script for APU4 + Debian 11, not recommended (use manual installation steps 1-13) 
1. `apt install wget && wget https://raw.githubusercontent.com/petrbol/RouterConfigurationTool/main/docs/`quickInstall1.sh && bash quickInstall1.sh` # executing will funish with reboot, after reboot continous to next step\
2. `wget https://raw.githubusercontent.com/petrbol/RouterConfigurationTool/main/docs/quickInstall2.sh && bash quickInstall2.sh`
3. rconfig vpp setup
   rconfig vpp set MainCore 1 Workers 2 && \
   rconfig save -f && \
   systemctl enable rctStart && \
   systemctl start rctStart

### Remove
`apt purge rct -y && rm -rf /etc/rct && reboot`

### How to upgrade
note: Upgrade via management interface is preferred. If `/etc/rct/startup.cfg` exist, service `rctStart` will be started and enabled after startup.
1. download latest rct version
2. dpkg -i rct-xxxx.deb
3. reload bash completion file (or logout & login to make bash-completion work again)\
`. /etc/profile.d/rconfig.sh`

### Useful commands
`rconfig save` # save running configuration to startup\
`rconfig commit` # apply configuration, no save\
`rconfig restore default` # restore configuration from default(created by `rconfig vpp setup`) to running without commit\
`rconfig commit dpdk` # perform full vpp & controlplane restart\
`rconfig address show`\
`birdc` # interactive bird debug cli\
`birdc c` # reload bird configuration\
`vppctl` # interactive vpp debug cli\
`ip netns exec controlplane ping 1.2.3.4` # ping 1.2.3.4\
`ip netns exec controlplane ip neighbor` #  show controlane neighbor\
`ip netns exec controlplane ip route` # show controlane routes\
`ip netns exec controlplane bash` # jump from management namespace to controlplane namespace (useful for debug)\
`systemctl status rctBird`\
`systemctl status rctExporter`\
`systemctl status rctExporterCp`\
`systemctl status rctSshd`\
`systemctl status rctVpp`

### Known issues
- jitter issue (about 6-10ms) can be observed on the PC Engines APU2/4 board with Debian 11 + original kernel. Custom kernel with ubuntu kernel .config fix this issue.
