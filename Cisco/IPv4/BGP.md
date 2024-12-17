# BGP configuration on Cisco devices


Terminology, general knowledge
---
- An autonomous zone is a collection of devies that logically belong together.
- An AS number is a uniuque number for the zone.

Prerequisites
---
- Order your routers into autonomous zones


Configuration
---

```
router bgp <autonomous_zone_number>
network <ip_address> mask <subnet_mask>
neighbor <ip_address_of_neighbor> remote-as <as_of_neighbour>
```
With this it should work

> [!NOTE]  
> You can configure additional settings.

```
! change the router id manually (otherwise it's the biggest IP the router has)
! format of an IP address, bigger is better
bgp router-id <id>

! change the keepalive interval
timers bgp

!
bgp log-neighbor-changes 
```


Minimum working config examples:
---