>### Main config file structure
```go
type ConfigFileStruct struct {
	Ethernet     []EthernetStruct
	Loopback     []LoopbackStruct
	BridgeDomain []BridgeDomainStruct
	Wireguard    []WireguardInterfaceStruct
	L2xConnect   []L2xConnectStruct
	Vxlan        []VxlanStruct
	Route        []RouteStruct
	Vpp          VppStruct
	Service      ServiceStruct
}

type VppStruct struct {
	MainCore              uint8
	Workers               uint8
	HugepagesSize         int64
	MainHeapSize          int64
	StatsegSize           int64
	LogToFile             bool
	DefaultLogLevel       string
	DefaultSyslogLogLevel string
}

type ServiceStruct struct {
	Bird struct {
		OnControlPlane ServiceCfgStruct
	}
	Sshd struct {
		OnControlPlane ServiceCfgStruct
	}
	Kea4 struct {
		OnControlPlane Kea4OnControlPlaneStruct
	}
	Kea6 struct {
		OnControlPlane Kea6OnControlPlaneStruct
	}
	Snmpd struct {
		OnManagement   SnmpdCfgStruct
		OnControlPlane SnmpdCfgStruct
	}
}

type Kea4OnControlPlaneStruct struct {
	Enable bool
}

type Kea6OnControlPlaneStruct struct {
	Enable      bool
	RouteHelper bool
}

type ServiceCfgStruct struct {
	Enable bool
}

type SnmpdCfgStruct struct {
	Enable       bool
	Community    Comment
	ListenOnAddr net.IP
	ListenOnPort uint16
}

type RouteStruct struct {
	UserInstance uint32
	Cfg          RouteCfgStruct
}

type RouteCfgStruct struct {
	Enable      bool
	Comment     Comment
	Destination ip_types.Prefix
	Gateway     ip_types.Address
	Interface   IfName
}

```
>### Interfaces structure
```go
type Nat44Struct struct {
	OutputFeature bool
	Address       ip_types.IP4Address
	StaticMap     bool
}

type RouterAdvertisementStruct struct {
	Enable      bool
	MaxInterval uint32
	MinInterval uint32
	Lifetime    uint32
	Managed     uint8
	Other       uint8
	Prefix      string
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
	Comment             Comment
	AdminUp             bool
	Address             []ip_types.AddressWithPrefix
	RouterAdvertisement RouterAdvertisementStruct
	Policy              []AbfPolicyStruct
	Nat44               Nat44Struct
	DpdkPciDeviceId     PciDeviceId
	DpdkRxQueues        uint8
	DpdkTxQueues        uint8
	Mtu                 uint32
}

type WireguardInterfaceStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          WireguardInterfaceCfgStruct
}

type WireguardInterfaceCfgStruct struct {
	Comment    Comment
	AdminUp    bool
	Address    []ip_types.AddressWithPrefix
	SrcAddress ip_types.Address
	ListenPort uint16
	PrivateKey string
	PublicKey  string
	Mtu        uint32
	Peer       []WireguardPeerStruct
}

type WireguardPeerStruct struct {
	PeerName IfName
	Cfg      WireguardPeerCfgStruct
}

type WireguardPeerCfgStruct struct {
	Comment             Comment
	DstAddress          ip_types.Address
	DstPort             uint16
	PublicKey           string
	AllowedIp           []ip_types.Prefix
	PersistentKeepalive uint16
}

// vlan struct
type VlanStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          VlanCfgStruct
}
type VlanCfgStruct struct {
	Comment             Comment
	AdminUp             bool
	Address             []ip_types.AddressWithPrefix
	RouterAdvertisement RouterAdvertisementStruct
	Policy              []AbfPolicyStruct
	Nat44               Nat44Struct
	Dot1q               Dot1q
	InnerDot1q          Dot1q
	ExactMatch          bool
	Pop1                bool
}

// loopback structures
type LoopbackStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          LooopbackCfgStruct
}
type LooopbackCfgStruct struct {
	Comment             Comment
	AdminUp             bool
	Address             []ip_types.AddressWithPrefix
	RouterAdvertisement RouterAdvertisementStruct
	Policy              []AbfPolicyStruct
	Nat44               Nat44Struct
	MacAddress          ethernet_types.MacAddress
	Mtu                 uint32
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