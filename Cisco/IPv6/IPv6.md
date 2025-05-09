---
title: IPv6 configuration on Cisco routers
tags:
  - basic
  - ipv6
---
Terminology, general knowledge
---
- It's got more features and mostly works differently from IPv4, it's not just a larger address space.

Prerequisites
---
- Router/MLS capable of IPv6

Sources
---
[Cisco](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipv6_basic/configuration/xe-3s/ip6b-xe-3s-book/ip6-add-basic-conn-xe.html)

Configuration
---

#### Router

> [!NOTE]  
> First you have to enable IPv6 on the router. It is off by default.

```
ipv6 unicast-routing
```

> [!NOTE]  
> Next you configure interfaces like in IPv4


```
interface <interface>
ipv6 address <address>/<prefix>
```

> [!IMPORTANT]  
> **Link local** addresses are generated only after the router knows that it is and IPv6 interface.
> If you give it an IPv6 address, it already knows. 
> Otherwise *if you don't intend to give it an address, you should still give out the following command to enable link local communication*

```
ipv6 enable
```

#### Multilayer switch:

> [!NOTE]  
> On some MLSs, you have to configure explicitly that you want to use dual stack IPv4 and IPv6. To do so, give the following command:

```
en
conf t
sdm prefer dual-ipv4-and-ipv6 default
do reload
```
Minimum working config examples:
---
Only configure a link-local address
```
ipv6 unicast-routing
interface gig0/0
ipv6 enable
```
