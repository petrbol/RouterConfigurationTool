### *** Most rconfig comands have more subcommands, use -h|--help ***
***
```
rconfig --help
rconfig [command] --help
rconfig show
```
***
### VPP configuration example
```
rconfig vpp set MainCore 0 Workers 3
```
***
### commit help
```
rconfig commit # commit updates only
rconfig commit dpdk # full load after dpdk modify
rconfig save # after succesfull commit
```
***
### manual ethernet interface add
```
rconfig ethernet add eth7
rconfig ethernet set eth7 DpdkPciDeviceId 0000:04:00.0 DpdkRxQueues 1 DpdkTxQueues 1
```
***
### ip address example
```
rconfig address add 192.168.15.1/24 interface enp3s0
rconfig address add 2a01:100::1/64 interface enp3s0
```
***
### loopback
```
rconfig loopback add loopBr1BVI
```
Add loopback name "loopBr1BVI".
***
### vlan L3 example 
L3 routing vlan, not bridge member.
```
rconfig vlan add vlan77 interface enp4s0
rconfig vlan set vlan77 Dot1q 77 ExactMatch true
rconfig address add 192.168.15.1/24 interface vlan77
```
ExacMatch true for L3.
***
### vlan L2 example
L3 routing vlan, not bridge member.
```
rconfig vlan add vlan77 interface enp4s0
rconfig vlan set vlan77 Dot1q 77 ExactMatch false Pop1 true
```
ExacMatch false. Pop1 options strip vlan header for bridge with other interface/bvi.
***
```
### vlan QinQ
rconfig vlan add vlan77 interface enp4s0
rconfig vlan set vlan77 Dot1q 77
rconfig vlan add vlanQinQ199 interface enp4s0
rconfig vlan set vlanQinQ199 Dot1q 77 InnerDot1q 199 ExactMatch true
```
Master interface (vlan with tag 77) must be declared to add QinQ vlan 199.
***
### bridge domain example
```
rconfig bridge add br1 # add bridge domain name br1
rconfig bridge set br1 Comment "test comment"
rconfig port add enp3s0 bridge br1
rconfig port add loopBr1BVI bridge br1
rconfig port add vlan77 bridge br1
rconfig port set loopBr1BVI PortType 1
```
PortType 1 is set to configure BVI.
