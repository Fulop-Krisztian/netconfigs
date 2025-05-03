# Debian (Networking, NetworkConfiguration)

tags: #ipv6 #ipv4 #basic #linux


Terminology, general knowledge
---


Prerequisites
---


Sources
---
https://wiki.debian.org/NetworkConfiguration

Configuration
---

### IPv6

#### Static only

```
iface eth0 inet6 static
	address 2001:db8::1234/64
	gateway 2001:db8::
```

#### SLAAC and static ULA

```bash
# manual unique local address
auto eth0
iface eth0 inet6 static
	address fd12:3456::3/64
	# use SLAAC to get global IPv6 address from the router
	# we may not enable ipv6 forwarding, otherwise SLAAC gets disabled
	autoconf 1
	accept_ra 2
```

Minimum working config examples:
---