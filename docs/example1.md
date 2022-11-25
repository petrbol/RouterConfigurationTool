>### topology
> r02 rct+VPP

![topology](../img/example1_topology.png?raw=true)

>### rconfig
> configuration commands
```
# additional ethernet configuration 
rconfig ethernet set enp2s0 DpdkRxQueues 2 DpdkTxQueues 2 AdminUp true
rconfig ethernet set enp4s0 DpdkRxQueues 2 DpdkTxQueues 2 AdminUp true

rconfig address add 10.10.15.51/24 interface enp2s0 

# loopback BVI for domain Br1Cust
rconfig loopback add loopBr1Cust
rconfig loopback set loopBr1Cust AdminUp true
rconfig address add 192.168.55.100/24 interface loopBr1Cust

# vlan declaration - L3 interface
rconfig vlan add vlan2600 interface enp4s0 
rconfig vlan set vlan2600 Dot1q 2600 ExactMatch true
rconfig address add 10.254.0.1/28 interface vlan2600

# vlan declaration - L2 interface => bridge member
rconfig vlan add vlan2601 interface enp4s0 
rconfig vlan add vlan2602 interface enp4s0 
rconfig vlan add vlan2603 interface enp4s0 
rconfig vlan set vlan2601 Dot1q 2601 Pop1 true AdminUp true
rconfig vlan set vlan2602 Dot1q 2602 Pop1 true AdminUp true
rconfig vlan set vlan2603 Dot1q 2603 Pop1 true AdminUp true

# bridge domain
rconfig bridge domain add Br1Cust
rconfig bridge port add loopBr1Cust bridge Br1Cust 
rconfig bridge port set loopBr1Cust PortType 1 
rconfig bridge port add vlan2601 bridge Br1Cust 
rconfig bridge port add vlan2602 bridge Br1Cust 
rconfig bridge port add vlan2603 bridge Br1Cust 
rconfig bridge port set vlan2601 Shg 1
rconfig bridge port set vlan2602 Shg 1
rconfig bridge port set vlan2603 Shg 1

# configure policy to secure traffic
rconfig abf policy add custPolicy interface loopBr1Cust
rconfig abf rule add custPolicy IsPermit 0 SrcPrefix 192.168.0.0/16 DstPrefix 192.168.0.0/16
rconfig abf rule add custPolicy IsPermit 1 SrcPrefix 192.168.0.0/16 DstPrefix 192.168.55.100/32
rconfig abf path add 10 policy custPolicy
rconfig abf path set 10 policy custPolicy ViaAddress 192.168.55.100 # to enable ping from 192.168.55.0/24 => 192.168.55.100/32

# enable services 
rconfig service bird onControlPlane set Enable true 
rconfig service sshd onControlPlane set Enable true 

# commit and save
rconfig commit
rconfig save
```
>### bird.conf
> example configuration
```
router id 10.254.0.1;
protocol device { scan time 30; }
protocol direct { ipv4; ipv6; check link yes; }
protocol kernel kernel4 {
    ipv4 { import all; export where source != RTS_DEVICE; };
    learn;
    scan time 300;
}

protocol kernel kernel6 {
    ipv6 { import all; export where source != RTS_DEVICE; };
    learn;
    scan time 300;
}

protocol ospf v2 {
    ipv4 { import all; export where source != RTS_DEVICE; };
    area 0.0.0.0 {
    interface "enp2s0" {
        authentication simple;
        dead 40;
        retransmit 5;
        hello 10;
        priority 1;
        cost 10;
        transmit delay 1;
        password "password";
    };
    interface "loopBr1Cust" {
        stub;
    };
    interface "vlan2600" {
        stub;
    };
    };
}
```