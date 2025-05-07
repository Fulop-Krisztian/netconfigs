---
title: Basic configurations using nmcli
tags:
  - linux
  - basic
  - etc
  - ipv4
  - ipv6
---
> [!TIP]
> Use **`nmtui`** if you can, it makes configuration much faster and simpler
> (You usually only configure interfaces once in a while anyways, so learning commands for small things is a waste of your time)

Prerequisites
---
- Your system uses [NetworkManager](https://wiki.archlinux.org/title/NetworkManager)
- Root privileges

IPv6
---
### Adding a static address

> [!NOTE]  
> IPv6 can have multiple addresses. You can add as many as you want to an interface like so

```bash
sudo nmcli con modify <connection_name> +ipv6.addresses "2a01:36d:600:692e::220/64"
```

> [!CAUTION]  
> The fact that IPv6 can have multiple addresses means that you can't that an address is automatically removed when configuring. 
> 
> Always check the resulting configuration from you commands, at least with the `ip address` command

IPv4
---

### Static IP address
```bash
sudo nmcli con modify <connection_name> ipv4.addresses <ip_address>/<subnet_mask>
```

```bash
sudo nmcli con modify <connection_name> ipv4.gateway <gateway_ip>
```

```bash
sudo nmcli con modify <connection_name> ipv4.method manual
```

```bash
sudo nmcli con modify <connection_name> ipv4.dns "<DNS_IP_1>,<DNS_IP_2>,<and so on>"
```

```bash
# reload the interface
sudo nmcli con up <connection_name>
```

### DHCP

```bash
sudo nmcli con modify <connection_name> ipv4.method auto
```

```bash
# reload the interface
sudo nmcli con up <connection_name>
```

Minimum working config examples:
---
```
sudo nmcli con modify bond0 ipv4.addresses 192.168.0.220/24
sudo nmcli con modify bond0 ipv4.gateway 192.168.0.1
sudo nmcli con modify bond0 ipv4.method manual
sudo nmcli con modify bond0 ipv4.dns "8.8.8.8,8.8.4.4"
sudo nmcli con up bond0
```