# OSPF configuration on Cisco devices
#router #dynamicrouting #ospf #cisco #ipv4

For OSPFv3, see [OSPFv3](OSPFv3.md)

Terminology, general knowledge
---


Prerequisites
---
- Already configured IP addresses

Sources
---


Configuration
---
### Recommended basic configuration


```
en
conf t
router ospf 1
no auto-summary
do sh ip rou | in C

network <ip> <subnet> area <area id> 

! for every IP that you see in the output of the last command
```


### Authentication
```

! Auth:
interface <interface> 
	ip ospf authentication message-digest
	ip ospf message-digest-key 1 md5 <password>

```


Minimum working config examples:
---
