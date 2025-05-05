---
title: EIGRP configuration on Cisco devices
tags:
  - router
  - dynamicrouting
  - eigrp
  - cisco
  - ipv4
---
Terminology, general knowledge
---
- EIGRP is supposedly the best interior gateway protocol
- Similar to RIP in workings: Path-vector based, but has metrics.

Prerequisites
---
- Router capable of EIGRP

Sources
---
[Default route configuration](https://www.cisco.com/c/en/us/support/docs/ip/enhanced-interior-gateway-routing-protocol-eigrp/200279-Configure-Default-route-in-EIGRP.html)
Configuration
---

### Advertising networks

> [!IMPORTANT] 
> You can't advertise any networks that isn't directly connected to the router on at least one interface that is up. (For example, 0.0.0.0)

```
en
conf t
router eigrp 1
no auto-summary
do sh ip rou | in C

! network <ip> <subnet> for every IP that you see in the output of the last command
```

### Default routes

#### Redistribute method:

> [!NOTE]  
> Advertising default routes. This is the way to advertise 0.0.0.0

```
router eigrp 1
! You can change the numbers (raise the first one to raise priority) to change the precedence if multiple default routes are advertized 
redistribute static metric 100000 1000 255 1 1500
```
### Authentication:

> [!IMPORTANT]
> You can only set up authentication with a keychain. It takes a while, and authentication is simpler for OSPF

#### Keychain configuration

```
! Keychain and key configuration
key chain <key_chain_name> 
	key <key_number> 
	! the following command is where you give the password:
	key-string <password>
```
#### Auth per interfaces

> [!NOTE]
> You have to configure authentication **per interface**

```
interface <interface>
	ip authentication mode eigrp <pid> md5
	! WARNING: You don't give the password, you give the keychain name
	ip authentication key-chain eigrp <pid> <key_chain_name>

```
Minimum working config examples:
---