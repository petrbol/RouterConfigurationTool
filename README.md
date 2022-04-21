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
2. modify /etc/default/grub
```
GRUB_CMDLINE_LINUX="isolcpus=1,2,3"
```