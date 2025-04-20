# Basic configurations using nmcli


Prerequisites
---
- A working computer
- Linux using NetworkManager
- Superuser privileges


**Use `nmtui` if you can, it makes configuration much faster and simpler**

IPv6
---
You should learn this eventually, or you will fall behind.

### Adding a static address

IPv6 can have multiple addresses. You can add as many as you want to an interface like so:

```bash
sudo nmcli con modify bond0 +ipv6.addresses "2a01:36d:600:692e::220/64"
```

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
```
sudo nmcli con modify <connection_name> ipv4.method auto
```

```
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