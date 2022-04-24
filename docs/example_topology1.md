>#### topology


>#### configuration commands
```
# additional ethernet configuration 
rconfig ethernet set enp2s0 DpdkRxQueues 2 DpdkTxQueues 2
rconfig ethernet set enp4s0 DpdkRxQueues 2 DpdkTxQueues 2

rconfig address add 10.10.15.51/24 interface enp2s0 

# loopback BVI for domain Br1Cust
rconfig loopback add loopBr1Cust
rconfig address add 192.168.55.100/24 interface loopBr1Cust

# vlan declaration - L3 interface
rconfig vlan add vlan2600 interface enp4s0 
rconfig vlan set vlan2600 Dot1q 2600 ExactMatch true
rconfig address add 10.254.0.1/28 interface vlan2600

# vlan declaration - L2 interface => bridge member
rconfig vlan add vlan2601 interface enp4s0 
rconfig vlan add vlan2602 interface enp4s0 
rconfig vlan add vlan2603 interface enp4s0 
rconfig vlan set vlan2601 Dot1q 2601 Pop1 true 
rconfig vlan set vlan2602 Dot1q 2602 Pop1 true 
rconfig vlan set vlan2603 Dot1q 2603 Pop1 true

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
rconfig abf rule add custPolicy IsPermit 0 SrcPrefix 192.168.55.0/24 DstPrefix 10.10.15.0/24

# enable services 
rconfig service set Bird true
rconfig service set ExporterCp true
rconfig service set Sshd true

# commit and save
rconfig commit
rconfig save
```
>#### bird.conf example configuration
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
>#### rconfig show # show current configuration
```json lines
{
 "Ethernet": [
  {
   "IfName": "enp2s0",
   "Cfg": {
    "Comment": "",
    "AdminUp": true,
    "Address": [
     "10.10.15.51/24"
    ],
    "Policy": null,
    "DpdkPciDeviceId": "0000:02:00.0",
    "DpdkRxQueues": 2,
    "DpdkTxQueues": 2,
    "Mtu": 1500
   },
   "Vlan": null
  },
  {
   "IfName": "enp3s0",
   "Cfg": {
    "Comment": "",
    "AdminUp": true,
    "Address": null,
    "Policy": null,
    "DpdkPciDeviceId": "0000:03:00.0",
    "DpdkRxQueues": 1,
    "DpdkTxQueues": 1,
    "Mtu": 1500
   },
   "Vlan": null
  },
  {
   "IfName": "enp4s0",
   "Cfg": {
    "Comment": "",
    "AdminUp": true,
    "Address": null,
    "Policy": null,
    "DpdkPciDeviceId": "0000:04:00.0",
    "DpdkRxQueues": 2,
    "DpdkTxQueues": 2,
    "Mtu": 1500
   },
   "Vlan": [
    {
     "IfName": "vlan2600",
     "UserInstance": 100,
     "Cfg": {
      "Comment": "",
      "AdminUp": true,
      "Address": [
       "10.254.0.1/28"
      ],
      "Policy": null,
      "Dot1q": 2600,
      "InnerDot1q": 0,
      "ExactMatch": true,
      "Pop1": false
     }
    },
    {
     "IfName": "vlan2601",
     "UserInstance": 101,
     "Cfg": {
      "Comment": "",
      "AdminUp": true,
      "Address": null,
      "Policy": null,
      "Dot1q": 2601,
      "InnerDot1q": 0,
      "ExactMatch": false,
      "Pop1": true
     }
    },
    {
     "IfName": "vlan2602",
     "UserInstance": 102,
     "Cfg": {
      "Comment": "",
      "AdminUp": true,
      "Address": null,
      "Policy": null,
      "Dot1q": 2602,
      "InnerDot1q": 0,
      "ExactMatch": false,
      "Pop1": true
     }
    },
    {
     "IfName": "vlan2603",
     "UserInstance": 103,
     "Cfg": {
      "Comment": "",
      "AdminUp": true,
      "Address": null,
      "Policy": null,
      "Dot1q": 2603,
      "InnerDot1q": 0,
      "ExactMatch": false,
      "Pop1": true
     }
    }
   ]
  }
 ],
 "Loopback": [
  {
   "IfName": "loopBr1Cust",
   "UserInstance": 0,
   "Cfg": {
    "Comment": "",
    "AdminUp": true,
    "Address": [
     "192.168.55.100/24"
    ],
    "Policy": [
     {
      "PolicyName": "custPolicy",
      "UserInstance": 0,
      "Comment": "",
      "IsIPv6": false,
      "Rules": [
       {
        "src_prefix": "192.168.55.0/24",
        "dst_prefix": "10.10.15.0/24"
       }
      ]
     }
    ],
    "MacAddress": "52:fd:fc:07:21:82",
    "Mtu": 1500
   }
  }
 ],
 "BridgeDomain": [
  {
   "IfName": "Br1Cust",
   "UserInstance": 1,
   "Cfg": {
    "Comment": "",
    "Flood": true,
    "UuFlood": true,
    "Forward": true,
    "Learn": true,
    "ArpTerm": false,
    "ArpUfwd": false
   },
   "Port": [
    {
     "IfName": "loopBr1Cust",
     "Comment": "",
     "PortType": 1,
     "Shg": 0
    },
    {
     "IfName": "vlan2601",
     "Comment": "",
     "PortType": 0,
     "Shg": 1
    },
    {
     "IfName": "vlan2602",
     "Comment": "",
     "PortType": 0,
     "Shg": 1
    },
    {
     "IfName": "vlan2603",
     "Comment": "",
     "PortType": 0,
     "Shg": 1
    }
   ]
  }
 ],
 "L2xConnect": null,
 "Vxlan": null,
 "Vpp": {
  "MainCore": 0,
  "Workers": 0,
  "LogToFile": false
 },
 "Services": {
  "Bird": true,
  "Sshd": false,
  "Watchdog": true,
  "Exporter": true,
  "ExporterCp": false
 }
}
```