# OSPFv3 confiugration on Cisco devices
#routing #dynamicrouting #ospf #cisco #ipv6

For regular OSPF, see [OSPF](Cisco/Routing%20protocols/OSPF.md)
Terminology, general knowledge
---
- You need to configure interfaces here instead of networks
- You need to set a router ID because it would use an IPv4 address, which we do not have now by default.


Prerequisites
---
- [IPv6](Cisco/IPv6/IPv6.md) networking is configured
- You don't actually need to configure addresses on intermediaries or point to point links between routers. Link local will take care of that (you do need to configure the router to use link local though, it will not make one automatically.).


Configuration
---
```
ipv6 rotuer ospf <PID>
router id <router_id>

interface <interface>
ipv6 ospf <PID> area <area>
```
Minimum working config examples:
---
```
! Router 1
ipv6 router ospf 1
! Assume gig0/0 is client facing
passive-interface gig0/0
router-id 1.1.1.1

interface gig0/0
ipv6 enable
ipv6 ospf 1 area 0

interface gig0/1
ipv6 enable
ipv6 ospf 1 area 0

! Router 2
ipv6 router ospf 1
! Assume gig0/0 is client facing
passive-interface gig0/0
router-id 1.1.1.2

interface gig0/0
ipv6 enable
ipv6 ospf 1 area 0

interface gig0/1
ipv6 enable
ipv6 ospf 1 area 0
```