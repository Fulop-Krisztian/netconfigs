#router  #dynamicrouting #rip #cisco #ipv4
# RIP configuration on Cisco devices

Terminology, general knowledge
---
- Use version 2. Always use version 2
- Give out the no auto-summary command. It will save you a lot of headache.

Prerequisites
---


Sources
---


Configuration
---
```
router rip
version 2
no auto-summary
network <network-number>

```


Minimum working config examples:
---


```
router rip
version 2
no auto-summary
network 10.0.0.1
```