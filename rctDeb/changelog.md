#### rct_0.2-6_amd64
- fix: improve ethernet link state handling VPP 23.02
- fix: rctWatchdog improper config file restoration
- fix: ipv6 ra not advertised on vlan interface
- new: carrier grade nat - Det44 implementation (communication with linux control plane not working, only static configuration using management port)

#### rct_0.2-5_amd64
- WARNING: abf policy structure reworked, manual reconfiguration is necessary
- WARNING: ipv6 RA structure reworked, old configuration will be lost, manual reconfiguration is necessary
- WARNING: mtu configuration struct reworked, old configuration will be lost, manual reconfiguration is necessary
- WARNING: nat44 configuration struct reworked, old configuration will be lost, manual reconfiguration is necessary
- new: command `rconfig ra add|del interfaName`
- new: command `rconfig nat44 add|del interfaceName`
- new: mtu configuration extended for packet/ipv4/ipv6, example `rconfig ethernet set Mtu|MtuIPv4|MtuIPv6 1500`
- new: add rctSnmpd wireguard interface statistics
- fix: invalid attempt to add LCP interface 

#### rct_0.2-4_amd64
- WARNING: static route configuration structure changed, remove all static routes before update
- new: wireguard initial implementation (look at the configurationExamples.md for details)
- new: add static route gateway via interface (look at the configurationExamples.md for details)
- new: reworked static route CLI (look at the configurationExamples.md for details)
- fix: rctKea6RouteHelper change set restored unknown routes expiration to 86400 
- fix: rctKea6RouteHelper removed netns attribute
- fix: make `rconfig commit dpdk` work inside controlplane
- new: add ipv6 ND configuration options lifetime, min, max, managed, other
- fix: change ipv6 RA default values to lifetime=1800, max=200, min=150, Managed=0, Other=0

#### rct_0.2-3_amd64
- WARNING: service structure reworked, past enabled service will not start automatically, enable it and commit & save again (bird,ssh...) - use MNG port to upgrade
- new: change VPP version and installation steps. Direct packages of VPP are used now (instead of VPP repos).
- new: command `rconfig show default`
- fix: check for commit done before `rconfig save default`
- new: argument --force argument to `rconfig save default -f`
- new: SNMP - initial SNMPd integration, systemd rctSnmpd|rctSnmpdCp service, command`rconfig service snmpd onControlPlane|onManagement set Enable true`
- new: SNMP - default listen on `0.0.0.0:161`, community `public`
- fix: change default add interface default AdminUp value to `false`
- removed: netns aliases `pingc, ipc, traceroutec`
- new: add rconfig command alias for `rconfig ping/ip/traceroute`
- removed: netns `sshc` alias, use `ip netns controlplane ssh user@ipAddress`
- new: add ipv6 RA command, example `rconfig ra set enp4s0 Enable true`
- new: add ipv6 RA configure default RA prefix, example `rconfig ra set enp4s0 Prefix 2a01:300::/56`
- removed: dhcp4client
- removed: rctExporter
- fix: change default static route metric to 2048
- fix: reconfigure static routes only if any static route is configured (to prevent reconfiguration stuck when large amount of routes - aka 1M)
- new: add isc kea4 + kea6 to the default installation manual
- new: reworked installation manual (using local deb packages)
- new: service systemd rctKea6RouteHelper (insert ipv6 delegated routes to the routing table, require specific kea HA configuration, default route metric 4096)
- new: enable IPv6 PD route injection from Kea `rconfig service kea6 set RouteHelper true`
- new: modified kea dhcp6 example to use with ipv6 PD route helper
- fix: change kernel net.core.rmem/wmem default value
- new: make kernel hugepages size configurable, default 2, size in G, eq:`rconfig vpp set MainHeapSize 6`
- new: make VPP main-heap-size configurable, default 1, size in G, eq:`rconfig vpp set MainHeapSize 2`
- new: make VPP statseg size configurable, default 32, size in M, eq:`rconfig vpp set StatsegSize 128` (eq: set size 128 for 1,5M routes)

#### rct_0.2-2_amd64
- new: rctExporter add current physical interface rate
- new: static route configuration
- new: kea4/6 dhcpd server preconfigured systemd service rctKea4 and rctKea6 (+rctKeaWatchdog to fix start on not running interface)
- new: add multiple aliases to run command in specific namespace (ping=>pingc, ip=>ipc, ssh=>sshc, traceroute=>traceroutec)
- new: simple source nat (nat44 output-feature on output interface: ethernet, vlan, loopback-bvi)
- new: dhcp4 client (ethernet, vlan, loopback-bvi)
- new: add command `rconfig save default`
- new: change command `rconfig bridge l2xconnect` => `rconfig l2xconnect`
- fix: updated grafana dashboard 
- fix: configuration is not full at the first commit
- known issue: dhcp client default route is not propagated to the controlplane, works in dataplane (will be fixed in next release) 

#### rct_0.2-1_amd64
- new: rctExporter export node_vpp_vector_rate per vector (vector=255 => max cpu usage)
- new: node_vpp_vector_rate => CPU graph grafana template
- new: rconfig commit --debug | rconfig commit dpdk --debug (enable verbose output for debug)
- new: rconfig vpp DefaultLogLevel & DefaultSyslogLogLevel options
- fix: rctExporter dynamic remove invalid values (removed interface etc.)
- fix: rconfig ethernet add (default MTU value to 1500)
- fix: sfp+ interface state up
- fix: vlan lcp create pair only for ExactMatch=true
- fix: lcp create pair commit message
- fix: improve commit messages
- fix: automatic start & enable service rctStart after upgrade
- fix: "ssh_exchange_identification: read: Connection reset by peer" after rctSshd stop
- info: rctExporter removed ExportInterfaceStats option

#### rct_0.2-0_amd64
- initial version

