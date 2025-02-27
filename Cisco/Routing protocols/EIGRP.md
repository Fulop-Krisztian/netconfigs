# EIGRP configuration on Cisco devices
#router #dynamicrouting #eigrp #cisco #ipv4 
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
router eigrp 1
no auto-summary
do sh ip rou | in C

! network <ip> <subnet> for every IP that you see in the output of the last command
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