# Redistributing routes between protocols

Terminology, general knowledge
---
- You can use multiple different kinds of protocols in a network, and redistribute between them to make it work

References
---
[OSPF](OSPF.md)
[OSPFv3](OSPFv3.md)
[EIGRP](EIGRP.md)
[BGP](BGP.md)

Prerequisites
---
Already configured at least two different kinds of dynamic routing protocols

Sources
---


Configuration
---
##### Overview:
```
router <protocol> <id>
redistribute <redistribute_source>

! Other things may be required based on what you redistribute from or to.

```

>[!WARNING]
> You need to give the PID of the protocol you source from, for example:
> `redistribute ospf 1 subnets`
> Notice the **1** after `ospf`

#### Redistributing into...
##### OSFP:

> [!NOTE]  \> OSPF
> For redisting to OSPF, you need a `subnets` at the end of the command
> `redistribute <protocol> subnets`

##### EIGRP:

> [!NOTE]  \> EIGRP
> For redisting to EIGRP, you need a bunch of numbers at the end because EIGRP uses those to do its metric calculation.
> `redistribute <protocol> metric 10000 100 255 1 1500`

##### RIP
> [!NOTE]  \> RIP
> For redisting to RIP, you need to set the metric.
> `redistribute <protocol> metric 1`


Minimum working config examples:
---
##### Source EIGRP into OSPF
```
router ospf 1
redistribute eigrp 1 subnets
```

##### Source OSPF into EIGRP
```
router eigrp 1
redistribute ospf 1 metric 10000 100 255 1 1500
```