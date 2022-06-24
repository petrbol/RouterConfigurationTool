>### Main config file structure
```go
type ConfigFileStruct struct {
	Ethernet     []EthernetStruct
	Loopback     []LoopbackStruct
	BridgeDomain []BridgeDomainStruct
	L2xConnect   []L2xConnectStruct
	Vxlan        []VxlanStruct
	Route        []RouteStruct
	Vpp          VppStruct
	Service      ServiceStruct
}

type VppStruct struct {
	MainCore              uint8
	Workers               uint8
	LogToFile             bool
	DefaultLogLevel       string
	DefaultSyslogLogLevel string
}

type ServiceStruct struct {
	Bird     ServiceCfgStruct
	Sshd     ServiceCfgStruct
	Exporter ExporterCfgStruct
	Kea4     ServiceCfgStruct
	Kea6     ServiceCfgStruct
}

type ServiceCfgStruct struct {
	EnableOnControlPlane bool
}

type ExporterCfgStruct struct {
	EnableOnManagement   bool
	EnableOnControlPlane bool
	ListenOnAddr         net.IP
	ListenOnPort         uint16
}

type RouteStruct struct {
	UserInstance uint32
	Comment      Comment
	Cfg          RouteCfgStruct
}

type RouteCfgStruct struct {
	Destination string
	Gateway     string
}

```
>### Interfaces structure
```go
package cfgStructures

import (
	"git.fd.io/govpp.git/binapi/acl_types"
	"git.fd.io/govpp.git/binapi/ethernet_types"
	"git.fd.io/govpp.git/binapi/ip_types"
	"git.fd.io/govpp.git/binapi/l2"
)

type Nat44Struct struct {
	OutputFeature bool
	Address       ip_types.IP4Address
	StaticMap     bool
}

type AbfPolicyStruct struct {
	PolicyName   IfName
	UserInstance uint32
	Comment      Comment
	IsIPv6       bool
	Paths        []AbfCfgPath
	Rules        []acl_types.ACLRule
}

type AbfCfgPath struct {
	PathID       uint8
	Weight       uint8
	ViaAddress   ip_types.Address
	ViaInterface IfName
}

// ethernet config struct
type EthernetStruct struct {
	IfName IfName
	Cfg    EthernetCfgStruct
	Vlan   []VlanStruct
}
type EthernetCfgStruct struct {
	Comment         Comment
	AdminUp         bool
	Address         []ip_types.AddressWithPrefix
	Dhcp4client     bool
	Policy          []AbfPolicyStruct
	Nat44           Nat44Struct
	DpdkPciDeviceId PciDeviceId
	DpdkRxQueues    uint8
	DpdkTxQueues    uint8
	Mtu             uint32
}

// vlan struct
type VlanStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          VlanCfgStruct
}
type VlanCfgStruct struct {
	Comment     Comment
	AdminUp     bool
	Address     []ip_types.AddressWithPrefix
	Dhcp4client bool
	Policy      []AbfPolicyStruct
	Nat44       Nat44Struct
	Dot1q       Dot1q
	InnerDot1q  Dot1q
	ExactMatch  bool
	Pop1        bool
}

// loopback structures
type LoopbackStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          LooopbackCfgStruct
}
type LooopbackCfgStruct struct {
	Comment     Comment
	AdminUp     bool
	Address     []ip_types.AddressWithPrefix
	Dhcp4client bool
	Policy      []AbfPolicyStruct
	Nat44       Nat44Struct
	MacAddress  ethernet_types.MacAddress
	Mtu         uint32
}

// bridge structures
type BridgeDomainStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          BridgeDomainCfgStruct
	Port         []BridgePortsCfgStruct
}
type BridgeDomainCfgStruct struct {
	Comment Comment
	Flood   bool
	UuFlood bool
	Forward bool
	Learn   bool
	ArpTerm bool
	ArpUfwd bool
}
type BridgePortsCfgStruct struct {
	IfName   IfName
	Comment  Comment
	PortType l2.L2PortType
	Shg      uint8
}

// vxlan
type VxlanStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          VxlanCfgStruct
}
type VxlanCfgStruct struct {
	Comment    Comment
	AdminUp    bool
	SrcAddress ip_types.Address
	DstAddress ip_types.Address
	SrcPort    uint16
	DstPort    uint16
	Vni        uint32
	Mtu        uint32
}

// L2xConnect
type L2xConnectStruct struct {
	IfName IfName
	Cfg    L2xConnectCfgStruct
}
type L2xConnectCfgStruct struct {
	Comment Comment
	PortA   IfName
	PortB   IfName
}

```