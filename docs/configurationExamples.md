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
rconfig vpp set MainCore 1 Workers 2
rconfig vpp set MainHeapSize 6
rconfig vpp set MainHeapSize 2
rconfig vpp set StatsegSize 128
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
rconfig ethernet set eth7 DpdkPciDeviceId 0000:04:00.0 DpdkRxQueues 1 DpdkTxQueues 1 AdminUp true
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
rconfig loopback set loopBr1BVI AdminUp true
```
Add loopback name "loopBr1BVI".
***
### vlan L3 example 
L3 routing vlan, not bridge member.
```
rconfig vlan add vlan77 interface enp4s0
rconfig vlan set vlan77 Dot1q 77 ExactMatch true AdminUp true
rconfig address add 192.168.15.1/24 interface vlan77
```
ExacMatch true for L3.
***
### vlan L2 example
L3 routing vlan, not bridge member.
```
rconfig vlan add vlan77 interface enp4s0
rconfig vlan set vlan77 Dot1q 77 ExactMatch false Pop1 true AdminUp true
```
ExacMatch false. Pop1 options strip vlan header for bridge with other interface/bvi.
***
### vlan QinQ
configure parent vlan + QinQ vlan 
```
rconfig vlan add vlan77 interface enp4s0
rconfig vlan set vlan77 Dot1q 77  AdminUp true
rconfig vlan add vlanQinQ199 interface enp4s0
rconfig vlan set vlanQinQ199 Dot1q 77 InnerDot1q 199 ExactMatch true AdminUp true
```
Master interface (vlan with tag 77) must be declared to add QinQ vlan 199.
***
### bridge domain example
```
rconfig bridge domain add br1 # add bridge domain name br1
rconfig bridge domain set br1 Comment "test comment"
rconfig bridge port add enp3s0 bridge br1
rconfig bridge port add loopBr1BVI bridge br1
rconfig bridge port add vlan77 bridge br1
rconfig bridge port set loopBr1BVI PortType 1
```
PortType 1 is set to configure BVI.
***
### simple Source NAT
configured on "wan" output interface\
OutputFeature = enable snat, established+related wan=>lan
Address = snat to ip address, must be set
MapLocal = enable access from internet to wan Address
```
rconfig nat44 set enp2s0 OutputFeature true Address 192.168.44.199 MapLocal true
rconfig nat44 set enp2s0 OutputFeature false
```
***
### snmpd
```
rconfig service snmpd onControlPlane set Enable true
rconfig commit
rconfig save
# edit `/etc/snmp/snmpd.conf` to set listen ip address
systemctl restart rctSnmpd.service
```
***
### IPv6 router advertisement
```
rconfig ra set enp4s0 Enable true 
rconfig ra set enp4s0 Prefix 2a01:500::/64
rconfig ra set enp4s0 Prefix none
```
***
### Static route
```
rconfig route add 10
rconfig route set 10 Destination 2a01:100::/64 Gateway 2a01:200::2 Enable true
rconfig route show
rconfig route del 10
```
***
### Wireguard
```
rconfig wireguard interface add wg0
rconfig wireguard interface set wg0 AdminUp true ListenPort 12345 PrivateKey xxxxx PublicKey xxxxx SrcAddress 1.2.3.4
rconfig address add 192.168.34.2/24 interface wg0
rconfig wireguard peer add newPeer1 wgInterface wg0
rconfig wireguard peer set newPeer1 AllowedIp 0.0.0.0/0,::/0 DstAddress 1.2.3.4 PersistentKeepalive 25 DstPort 12345 PublicKey xxxx
rconfig route add 21
rconfig route set 21 Enable true Destination 10.0.0.0/8 Gateway 192.168.34.1

# for direct communication with end of remote tunnel, add /32|/128 address directly via interface
rconfig route add 22
rconfig route set 22 Enable true Destination 192.168.34.1/32 Interface wg0
```
***
### ABF policy filtering
```
# loop0br0 is input interface with ipv4 192.168.54.100
# enp2s0 is outbound interface
# lower Weight pass first
rconfig abf policy add custPolicy interface loop0br0
rconfig abf path add path1 policy custPolicy 
rconfig abf path add path2 policy custPolicy
rconfig abf path set path1 ViaAddress 192.168.54.100 Weight 10
rconfig abf path set path2 ViaInterface enp2s0 Weight 20
rconfig abf rule add path1 SrcPrefix 192.168.0.0/16 DstPrefix 192.168.54.100/32 IsPermit 1
rconfig abf rule add path2 SrcPrefix 192.168.0.0/16 DstPrefix 192.168.0.0/16 IsPermit 0
rconfig abf rule add path2 SrcPrefix 192.168.0.0/16 DstPrefix 10.10.0.0/16 IsPermit 0
rconfig abf rule add path2 SrcPrefix 192.168.0.0/16 DstPrefix 10.254.0.0/16 IsPermit 0
```
***
### CgNAT Det44 example
```
rconfig det44 set enp2s0 Feature outside
rconfig det44 set enp3s0 Feature inside
rconfig det44 prefix add 10
rconfig det44 prefix set 10 Inside 192.168.15.0/24 Outside 1.2.3.0/30
rconfig det44 show
rconfig det44 prefix del 10
```