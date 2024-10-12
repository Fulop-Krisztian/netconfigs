# IP configuration with nmcli


Prerequisites
---
- A working computer
- Linux using NetworkManager
- Superuser privileges


Configuration (IPv4)
---

### Static IP address
```
sudo nmcli con modify <connection_name> ipv4.addresses <ip_address>/<subnet_mask>
```

```
sudo nmcli con modify <connection_name> ipv4.gateway <gateway_ip>
```

```
sudo nmcli con modify <connection_name> ipv4.method manual
```

```
sudo nmcli con modify <connection_name> ipv4.dns "<DNS_IP_1>,<DNS_IP_2>,<and so on>"
```

```
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