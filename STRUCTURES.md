```go
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
	Comment    Comment
	AdminUp    bool
	Address    []ip_types.AddressWithPrefix
	Dot1q      Dot1q
	InnerDot1q Dot1q
	ExactMatch bool
	Pop1       bool
}

// loopback structures
type LoopbackStruct struct {
	IfName       IfName
	UserInstance uint32
	Cfg          LooopbackCfgStruct
}
type LooopbackCfgStruct struct {
	Comment    Comment
	AdminUp    bool
	Address    []ip_types.AddressWithPrefix
	MacAddress ethernet_types.MacAddress
	Mtu        uint32
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