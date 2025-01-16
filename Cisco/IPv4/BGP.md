# BGP configuration on Cisco devices


Terminology, general knowledge
---
- An autonomous zone is a collection of devies that logically belong together.
- An AS number is a uniuque number for this zone.
- The range of AS numbers 64512 - 65534 is for private use (according to IANA, who assigns these numbers)
- Default BGP uses (used) 2 bytes (~65000), contemporary BGP uses 4 bytes (~65000*65000) for AS numbers
- BGP uses **TCP 179**
- The peering is not automatic, it's manually configured
- IBGP: Routing withing an AS, EBPG: Routing between Autonomous Systems.
- Only looks at the number of AS jumps *by default*, however bad the link may be
- The table for BGP routes look something like this:

| Destination  | Next hop  | ASPATH    |
| -----------  | --------  | ------    |
| 10.18.0.0/16 | 10.18.0.1 | 202,i     |
| 10.18.0.0/16 | 10.17.0.1 | 201,202,i |

Prerequisites
---
- Order your routers into autonomous zones logically
- Have a peer you can connect to

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
