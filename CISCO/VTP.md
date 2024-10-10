# VTP configuration for cisco switches

> [!NOTE]
> IP addresses are not required, VTP operates in layer 2

```
! default is server mode for all routers
vtp mode server
! you can set it to client
vtp mode client
! or transparent
vtp mode transparent


! next you need to set a domain. The name can be anything but must be the same between switches
vtp domain (name)

! next is a password
vtp password (password)

! you can set the version as well
vtp version (1,2,3)
```


Minimal configurations:
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

