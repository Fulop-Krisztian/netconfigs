# EIGRP configuration on Cisco devices
#routing #dynamicrouting #eigrp #cisco #ipv4 
Terminology, general knowledge
---
- EIGRP is supposedly the best interior gateway protocol
- Similar to RIP in workings: Path-vector based, but has metrics.

Prerequisites
---
- Router capable of EIGRP

Sources
---

Configuration
---

> [!NOTE] 
> Basic configuration

```
en
conf t
router ospf 1
no auto-summary
do sh ip rou | in C

network <ip> <subnet> area <area id> 

! for every IP that you see in the output of the last command
```


> [!NOTE]
> Authentication

```

! Auth:
ip ospf authentication message-digest
interface <interface> message-digest-key 1 md5 <password>

```

Minimum working config examples:
---