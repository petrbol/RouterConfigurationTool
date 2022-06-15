### ISC Kea DHCPv4/6 server
***
>#### Install:
```
curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-0/setup.deb.sh' | sudo -E bash
apt update
apt install isc-kea-dhcp4-server
apt install isc-kea-dhcp6-server
systemctl stop isc-kea-dhcp4-server
systemctl stop isc-kea-dhcp6-server
systemctl disable isc-kea-dhcp4-server
systemctl disable isc-kea-dhcp6-server
```

>#### Enable systemd preconfigured Kea service
```
rconfig service set kea4 set EnableOnControlPlane true
rconfig service set kea6 set EnableOnControlPlane true
# to reload service use
systemctl reload rctKea4 | systemctl restart rctKea4
systemctl reload rctKea6 | systemctl restart rctKea6
```
>#### Example: /etc/kea/kea-dhcp4.conf
```json lines
{
   "Dhcp4":{
      "valid-lifetime":4000,
      "renew-timer":1000,
      "rebind-timer":2000,
      "interfaces-config":{
         "interfaces":[
            "enp4s0"
         ]
      },
      "lease-database":{
         "type":"memfile",
         "persist":true,
         "name":"/var/lib/kea/dhcp4.leases"
      },
      "subnet4":[
         {
            "subnet":"192.168.19.0/24",
            "pools":[
               {
                  "pool":"192.168.19.40 - 192.168.19.80"
               }
            ],
            "option-data":[
               {
                  "name":"routers",
                  "data":"192.168.19.1"
               },
               {
                  "name":"domain-name-servers",
                  "data":"8.8.8.8, 1.1.1.1"
               }
            ]
         }
      ]
   }
}
```