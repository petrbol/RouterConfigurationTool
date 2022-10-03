>### topology
> r01, r02 = rct+VPP

![topology](../img/example2_topology.png?raw=true)

>### rconfig
> configuration commands
```
rconfig vpp set MainCore 0 Workers 3
rconfig ethernet set enp2s0 DpdkRxQueues 2 DpdkTxQueues 2 AdminUp true
rconfig ethernet set enp3s0 DpdkRxQueues 2 DpdkTxQueues 2 AdminUp true
rconfig ethernet set enp4s0 DpdkRxQueues 2 DpdkTxQueues 2 AdminUp true

rconfig address add 10.10.19.1/24 interface enp2s0

rconfig loopback add loop1Vxlan
rconfig loopback set loop1Vxlan AdminUp true
rconfig address add 10.254.100.1/32 interface loop1Vxlan

rconfig vxlan add vxlan110
rconfig vxlan set vxlan110 SrcAddress 10.254.100.1 DstAddress 10.254.100.2 Vni 110 AdminUp true

rconfig l2xconnect add enp3s0Vxlan110
rconfig l2xconnect set enp3s0Vxlan110 PortA enp3s0 PortB vxlan110

rconfig service bird set EnableOnControlPlane true 
rconfig service sshd set EnableOnControlPlane true

rconfig commit dpdk
rconfig save
```
>### bird.conf
> example configuration
```
router id 10.254.100.1;
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
    interface "loop1Vxlan" {
        stub;
    };
    };
}
```