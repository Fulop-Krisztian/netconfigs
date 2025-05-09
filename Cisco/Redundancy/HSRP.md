---
title: HSRP Configuration on Cisco Devices
tags:
  - cisco
  - ipv4
  - ipv6
  - router
  - vlan
---


Terminology, general knowledge
---
- HSRP (Hot Standby Routing Protocol) is a protocol used to provide high availability and redundancy for the first hop (default gateway) of a network.
- HSRP allows multiple routers to share the same IP address, with only one router actively forwarding traffic at any given time.
- The other routers are in standby mode, waiting for the active router to fail.

Prerequisites
---
- Two Cisco routers at least, since HSPR is proprietary.

Configuration
---

### HSRP Basics
-   Virtual IPs belong to HSRP groups
-   Each HSRP group has a unique number (0-255) that identifies it.
-   The active router is responsible for forwarding traffic, while the standby router waits in standby mode.
-   When the active router fails, the standby router takes over as the new active router.

### HSRP Configuration

> [!IMPORTANT]
> - You give the "Virtual IP" that the two routers will share. 
> - The two routers still need to have a normal IP address configured on an interface in the same subnet. 
```
standby <group_number> ip <ip_address>
```

With this you are pretty much done. Do this on two routers and it will work.


### HSRP Priority

> [!TIP]
> You can give a priority value which determines which router will become the active router. **Higher is better**
```
!
interface <interface>
ip address <ip_address> <subnet_mask>
standby priority <value>
end
```

> [!WARNING]
> Make sure the Virtual IP address and standby group number are the same on both routers, and that they both have an interface in the same subnet

### HSRP Preemption

*   Enables a higher-priority router to preempt an active router if the priority difference is less than 10.
*   Can be used to ensure that a router with a higher priority takes over as soon as possible.

```
interface <interface>
hsrp preempt (delay minimum <delay_time>)
```


Minimum working config examples:
---

Here is an example configuration where two routers (R1 and R2) are configured for HSRP with the virtual IP address of 192.168.1.100:

```
R1:
enable
configure terminal
standby 10 ip 192.168.1.100

interface gig0/0
! Notice how neither of the routers configure the IP on any actual interfaces
ip address 192.168.1.1 255.255.255.0
! Priority is optional. Higher is better
standby priority 150


R2:
enable
configure terminal
standby 10 ip 192.168.1.100

interface gig0/0
! Notice how neither of the routers configure the IP on any actual interfaces
ip address 192.168.1.2 255.255.255.0
! Priority is optional. Higher is better
standby priority 110
```