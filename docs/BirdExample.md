>### Bird2 configuration
> bird,conf file example

```
router id 1.1.1.1;
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

protocol static {
    ipv4;
    route 10.0.0.200/32 via 10.10.20.2;
}

protocol static {
    ipv6;
    route 2a06:600::/64 via 2a06:500::2;
}

protocol ospf v2 {
    ipv4 { import all; export where source != RTS_DEVICE; };
    area 0.0.0.0 {
	interface "enp2s0" {
	    authentication cryptographic;
	    dead 40;
	    retransmit 5;
	    hello 10;
	    priority 1;
	    cost 10;
	    transmit delay 1;
	    password "password";
	};
	interface "loop1Br1" {
	    stub;
        };
    };
}

protocol ospf v3 {
    ipv6 { import all; export where source != RTS_DEVICE; };
    area 0.0.0.0 {
	interface "enp2s0" {
	    dead 40;
	    retransmit 5;
	    hello 10;
	    priority 1;
	    cost 10;
	    transmit delay 1;
	};
    };
}
```
