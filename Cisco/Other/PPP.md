---
title: PPP with CHAP configuration for Cisco routers
tags:
  - cisco
---
Terminology, general knowledge
---
- PPP works in a weird way. You will need to configure neighboring devices as if they were users. username = hostname, password = password
- You configure this per interface. Both interfaces must be configured

Configuration
---



Minimum working config examples:
---

Router1

```ios
enable
configure terminal
interface Serial0/0/0
ip address 192.168.1.1 255.255.255.252

encapsulation ppp

! This is optional, if ommited it uses the hostname of the router
ppp chap hostname Router1
ppp chap password mypassword
no shutdown


! You need to give the credentials of the connected router here
username Router2 password mypassword2

```

Router2

```ios
enable
configure terminal
interface Serial0/0/0
ip address 192.168.1.2 255.255.255.252

encapsulation ppp

! This is optional, if ommited it uses the hostname of the router
ppp chap hostname Router2
ppp chap password mypassword2
no shutdown


! You need to give the credentials of the connected router here
username Router1 password mypassword
```



