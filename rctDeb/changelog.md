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
