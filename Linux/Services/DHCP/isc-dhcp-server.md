---
title: ISC DHCP server configuration on Linux
tags:
  - ipv4
  - ipv6
  - linux
  - etc
  - service
  - automation
---
Terminology, general knowledge
---
- isc-dhcp-server is outdated ([end of maintenance as of 2022](https://www.isc.org/dhcp/) ), don't even consider it in real applications. An alternative is [Kea](https://kea.readthedocs.io/en/latest/arm/intro.html), developed by the same group.

Prerequisites
---
- isc-dhcp-server is installed (`apt install isc-dhcp-server`)

Sources
---
[Ubuntu wiki](https://documentation.ubuntu.com/server/how-to/networking/install-isc-dhcp-server/index.html)

Configuration
---
First you should configure the interfaces

`/etc/default/isc-dhcp-server`

```isc-dhcp-server
INTERFACESv4="enp0s7"
```

 `/etc/dhcp/dhcpd.conf`

```dhcpd.conf
# minimal sample /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;
    
subnet 192.168.1.0 netmask 255.255.255.0 {
	range 192.168.1.150 192.168.1.200;
	option routers 192.168.1.254;
	option domain-name-servers 192.168.1.1, 192.168.1.2;
	option domain-name "mydomain.example";
}
```

Finally restart the service to apply the configuration

```bash
systemctl restart isc-dhcp-server
```