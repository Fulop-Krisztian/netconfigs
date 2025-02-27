# VTP configuration for cisco switches
#cisco #switch #vlan #automation 

Terminology, general knowledge
---
- VTP means VLAN Trunk protocol, which means Virtual Local Area Network Trunk Protocol.
- This propagates all the VLANs you configure on a master switch to all other switches it can reach.

Prerequisites
---
- Switched LAN with managed switches

Sources
---

[Cisco](https://www.cisco.com/c/en/us/support/docs/lan-switching/vtp/10558-21.html)

Configuration
---
> [!NOTE]
> IP addresses are not required, VTP operates in layer 2

```
! default is server mode for all routers
vtp mode server
! you can set it to client
vtp mode client
! or transparent (it doesn't learn the VLANs, but passes the information through)
vtp mode transparent


! next you need to set a domain. The name can be anything but must be the same between switches
vtp domain (name)

! next is a password
vtp password (password)

! you can set the version as well
vtp version (1,2,3)
```
> [!TIP]
> According to llama 3, these are how the different versions differ
> | Feature | VTPv1 | VTPv2 | VTPv3 |
> | --- | --- | --- | --- |
> | Maximum VLANs | 16 | 16,000 | 4094 (Enhanced Mode), 1024 (Standard Mode) |
> | Encryption of VTP Packets | No | No | Yes |
> | VLAN Pruning | Limited | Enhanced | Further Enhancements in Enhanced Mode |
> | Filtering by VLAN List | No | Yes | Yes |
> | Allowed and Denied VLANs | No | No (Only Filtering) | Yes, can set both allowed and denied VLANs |
> | Domain Name/ IP Address Advertisement | No | No | Yes |
> | Support for Other Protocols | Limited | Limited | Supports additional protocols |


Minimum working config examples:
---

Server:
```
enable
configure terminal
vtp domain MyDomain
vtp mode server
vtp version 2
vtp password cisco123
```

Client
```
enable
configure terminal
vtp domain MyDomain
vtp mode client
vtp version 2
vtp password cisco123
```

Transparent
```
enable
configure terminal
vtp domain MyDomain
vtp mode transparent
vtp version 2
```

