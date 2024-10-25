# IPv6 configuration on Cisco routers

Terminology, general knowledge
---
- It's got more features and mostly works differently from IPv6, it's not just a larger address space.

Prerequisites
---
- Router capable of IPv6

Sources
---
[Cisco](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipv6_basic/configuration/xe-3s/ip6b-xe-3s-book/ip6-add-basic-conn-xe.html)

Configuration
---

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


Minimum working config examples:
---