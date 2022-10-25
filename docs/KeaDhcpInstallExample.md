### ISC Kea DHCPv4/6 server

***
> #### Install:

```
curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-0/setup.deb.sh' | sudo -E bash
apt update
apt install isc-kea-dhcp4-server
apt install isc-kea-dhcp6-server
apt install radvd
systemctl stop isc-kea-dhcp4-server
systemctl stop isc-kea-dhcp6-server
systemctl stop radvd
systemctl disable isc-kea-dhcp4-server
systemctl disable isc-kea-dhcp6-server
systemctl disable radvd
```

> #### Enable systemd preconfigured Kea service

```
rconfig service kea4 set EnableOnControlPlane true
rconfig service kea6 set EnableOnControlPlane true
rconfig service radvd set EnableOnControlPlane true

# to reload service use
systemctl reload rctKea4 | systemctl restart rctKea4
systemctl reload rctKea6 | systemctl restart rctKea6
systemctl reload rctRadvd | systemctl restart rctRadvd
```

> #### Example: /etc/kea/kea-dhcp4.conf

```json lines
{
  "Dhcp4": {
    "valid-lifetime": 4000,
    "renew-timer": 1000,
    "rebind-timer": 2000,
    "interfaces-config": {
      "interfaces": [
        "enp4s0"
      ]
    },
    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/lib/kea/dhcp4.leases"
    },
    "subnet4": [
      {
        "subnet": "192.168.19.0/24",
        "pools": [
          {
            "pool": "192.168.19.40 - 192.168.19.80"
          }
        ],
        "option-data": [
          {
            "name": "routers",
            "data": "192.168.19.1"
          },
          {
            "name": "domain-name-servers",
            "data": "8.8.8.8, 1.1.1.1"
          }
        ]
      }
    ]
  }
}
```

#### Example kea-dhcp6.conf

```json lines
{
  "Dhcp6": {
    "interfaces-config": {
      "interfaces": [
        "loopBridgeCust"
      ]
    },
    "lease-database": {
      "type": "memfile",
      "lfc-interval": 3600
    },
    "renew-timer": 1000,
    "rebind-timer": 2000,
    "preferred-lifetime": 3000,
    "valid-lifetime": 4000,
    "option-data": [
      {
        "name": "dns-servers",
        "data": "2001:db8:2::45, 2001:db8:2::100"
      }
    ],
    "subnet6": [
      {
        "interface": "loopBridgeCust",
        "subnet": "2a01:500::/64",
        "reservations": [
          {
            "hw-address": "6C:3B:6B:7B:C7:C9",
            "ip-addresses": [
              "2a01:500::2"
            ],
            "prefixes": [
              "2a01:600::/56"
            ]
          }
        ]
      }
    ],
    "loggers": [
      {
        "name": "kea-dhcp6",
        "output_options": [
          {
            "output": "stdout",
            "pattern": "%-5p %m\n"
          }
        ],
        "severity": "INFO",
        "debuglevel": 0
      }
    ]
  }
}
```
#### Example /etc/radvd.conf
```
interface loopBridgeCust
{
    MinRtrAdvInterval 3;
    MaxRtrAdvInterval 4;
    AdvSendAdvert on;
    AdvManagedFlag on;
    prefix 2a01:500::/64 {
        AdvValidLifetime 14300;
        AdvPreferredLifetime 14200;
    };
};
```