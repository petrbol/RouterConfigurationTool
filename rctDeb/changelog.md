#### rct_0.2-3_amd64
- know issue: controlplane does not have default route from dhcp client
- fix: check for commit done before `rconfig save default` 
- new: add command `rconfig show default`
- new: SNMP - add systemd rctSnmpd service, command`rconfig service snmpd set EnableOnControlPlane true`, use`/etc/snmp/snmpd.conf`cfg file, install first`apt isntall snmpd -y`
- fix: change default add interface default AdminUp value to `false`

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
