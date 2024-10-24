# Title

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
router eigrp 1
no auto-summary
do sh ip rou | in C

! network <ip> <subnet> for every IP that you see in the output of the last command
```

```
en
conf t
router ospf 1
no auto-summary
do sh ip rou | in C

network <ip> <subnet> area <area id> 

! for every IP that you see in the output of the last command

! Auth:
ip ospf authentication message-digest
interface <interface> message-digest-key 1 md5 <password>

```

### Redistribute


```
router <protocol> <id>
redistribute <redistribute_source>
! Other things may be required based on what you redistribute from or to.

! For redisting to OSPF, you need a subnets at the end of the command
! For redisting to EIGRP, you need a bunch of numbers at the end because EIGRP uses those to do its metric calculation.
```


Minimum working config examples:
---