### ISC Kea DHCPv4/6 server

***
> #### Enable systemd preconfigured Kea service

```
rconfig service kea4 set EnableOnControlPlane true
rconfig service kea6 set EnableOnControlPlane true

# to reload service use
systemctl reload rctKea4 | systemctl restart rctKea4
systemctl reload rctKea6 | systemctl restart rctKea6
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

>#### Example /etc/kea/kea-dhcp6.conf

```json lines
{
  "Dhcp6": {
    "interfaces-config": {
      "interfaces": [
        "enp4s0"
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
    "hooks-libraries": [
      {
        "library": "/usr/lib/x86_64-linux-gnu/kea/hooks/libdhcp_lease_cmds.so",
        "parameters": { }
      },
      {
        "library": "/usr/lib/x86_64-linux-gnu/kea/hooks/libdhcp_ha.so",
        "parameters": {
          "high-availability": [ {
            "this-server-name": "server1",
            "mode": "passive-backup",
            "wait-backup-ack": false,
            "peers": [{
              "name": "server1",
              "url": "http://127.0.0.1:8000/",
              "role": "primary"
            }, {
              "name": "server2",
              "url": "http://127.0.0.1:8082/",
              "role": "backup"
            }]
          } ]
        }
      }
    ],
    "subnet6": [
      {
        "interface": "enp4s0",
        "subnet": "2a01:500::/64",
        "reservations": [
          {
            "hw-address": "B4:FB:E4:5C:40:3F",
            "ip-addresses": [
              "2a01:500::2"
            ],
            "prefixes": [
              "2a01:600::/56"
            ]
          },{
            "hw-address": "6C:3B:6B:7B:C7:C9",
            "ip-addresses": [
              "2a01:500::3"
            ],
            "prefixes": [
              "2a01:700::/56"
            ]
          }
        ]
      }
    ]
  }
}
```
