# NAT konfiguráció cisco eszközökön

Terminology, general knowledge
---


Prerequisites
---
- Belső és külső IP címek
- Legalább 1 globális IP cím

Sources
---

Configuration
---

> [!NOTE]  
> Static one-to-one

```
ip nat inside source static <local_ip> <global_ip>

! now we define the inside and outside interfaces
interface <inside_interface>
ip nat inside
interface <outide_interface>
ip nat outside
```


> [!NOTE]  
> Dynamic translation with pool configuration (with optional overload)

We define what global addresses we want to translate to.
```
! The pool of addresses we translate to
ip nat pool <name> <start_ip> <end_ip> netmask <mask>
```

We define the local addresses we want to translate
```
! What adresses we translate
ip access-list standard <name>
permit <ip> <wildcard_mask(optional)>
```

We give out the NAT command and configure the interfaces.
```
! The NAT command
ip nat inside source list <acl_name> pool <nat_pool_name> (overload)
```
Configure the interfaces.
```
! Configure inside and outside interfaces
interface <inside_interface>
ip nat inside
interface <outide_interface>
ip nat outside
```



Minimum working config examples:
---

PAT:
```
ip nat pool OUT 10.10.10.0 10.10.10.10 netmask 255.255.255.0

ip access list standard IN
permit 192.168.0.0 0.0.0.255
exit

ip nat inside source list IN pool OUT overload

interface gig0/1
ip nat inside

interface se0/0/0
ip nat outside
```