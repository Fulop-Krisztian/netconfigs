# OSPFv3 confiugration on Cisco

Terminology, general knowledge
---
- You need to configure interfaces here instead of networks
- You need to set a router ID because it would use an IPv4 address, which we do not have now by default.


Prerequisites
---
- IPv6 networking is configured



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