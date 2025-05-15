---
title: EIGRP OSPF RIP redistribute chap authentication
tags:
  - project
  - cisco
  - dynamicrouting
  - eigrp
  - ospf
  - rip
  - basic
  - ipv4
  - router
  - switch
  - vlan
---
This was a class project, dated 2025-02-27
# Subnets:

| VLAN | Subnet     | Prefix | Total Addresses | Usable Range            | Router IP  |
| ---- | ---------- | ------ | --------------- | ----------------------- | ---------- |
| 158  | 10.0.0.0   | /24    | 256             | 10.0.0.1 – 10.0.0.254   | 10.0.0.1   |
| 32   | 10.0.1.0   | /26    | 64              | 10.0.1.1 – 10.0.1.62    | 10.0.1.1   |
| 26   | 10.0.1.64  | /27    | 32              | 10.0.1.65 – 10.0.1.94   | 10.0.1.65  |
| 24   | 10.0.1.96  | /27    | 32              | 10.0.1.97 – 10.0.1.126  | 10.0.1.97  |
| 18   | 10.0.1.128 | /27    | 32              | 10.0.1.129 – 10.0.1.158 | 10.0.1.129 |
| 16   | 10.0.1.160 | /27    | 32              | 10.0.1.161 – 10.0.1.190 | 10.0.1.161 |
| 8    | 10.0.1.192 | /28    | 16              | 10.0.1.193 – 10.0.1.206 | 10.0.1.193 |
| –    | 10.0.1.208 | /30    | 4               | 10.0.1.209 – 10.0.1.210 | 10.0.1.209 |

Topics covered:
[EIGRP](../Routing%20protocols/EIGRP.md)
[OSPF](../Routing%20protocols/OSPF.md)
[RIP](../Routing%20protocols/RIP.md)
[Redistribute](../Routing%20protocols/Redistribute.md)
[PPP](../Other/PPP.md)
[ACLs](../Other/ACLs.md)

# Configurations

[Routers](#Routers)
	[Router0](#Router0)
	[ROUTER1](#ROUTER1)
	[Router2](#Router2)
	[Rotuer3](#Rotuer3)
	[Router4](#Router4)
	[Router5](#Router5)
	[Router6](#Router6)

[Switchek](#Switchek)
	[Switch1](#Switch1)
	[Switch0](#Switch0)
	[Switch2](#Switch2)
	[Switch3](#Switch3)
	[Switch4](#Switch4)
	[Switch5](#Switch5)

## Routers
Router0
---

```

! Router0
en
conf t

! Change
hostname Router0 

! Keychain
key chain eigrp_keychain
	key 1
	! the following command is where you give the password:
	key-string ojajnememgy

! interface configurations

	! > ROUTER 1
	interface se0/0/0
		no shutdown
		ip address 10.255.0.1 255.255.255.252
		! Auth
		ip authentication mode eigrp 1 md5
		ip authentication key-chain eigrp 1 eigrp_keychain
		! PPP with CHAP
		encapsulation ppp
		ppp chap hostname Router0
		ppp chap password tutilesz
		username ROUTER1 password tutilesz
		
	! > LAN
	interface fa0/0
		no shutdown

	interface fa0/0.8
		no shutdown
		encapsulation dot1q 8
		ip address 10.0.1.193 255.255.255.240
		ip helper-address 10.0.1.210
		
	interface fa0/0.16
		no shutdown
		encapsulation dot1q 16
		ip address 10.0.1.161 255.255.255.224
		ip helper-address 10.0.1.210
		

	! EIGRP
		router eigrp 1
		no auto-summary
			network 10.255.0.1 255.255.255.252
			network 10.0.1.161 255.255.255.224
			network 10.0.1.193 255.255.255.240

! ACL:
	
	! VLAN 8 és VLAN 24 között ne legyen ping
		ip access-list extended NOPING_VLAN_8-VLAN_24
		! Out
		deny icmp 10.0.1.192 0.0.0.15 10.0.1.64 0.0.0.31 echo
		deny icmp 10.0.1.192 0.0.0.15 10.0.1.64 0.0.0.31 echo-reply
		
		! In
		! (The "Out" part alone should be enough for apparent functioning, but this way we even prevent a machine recieving a ping but being unable to reply to it.)
		deny icmp 10.0.1.64 0.0.0.31 10.0.1.192 0.0.0.15  echo
		deny icmp 10.0.1.64 0.0.0.31 10.0.1.192 0.0.0.15 echo-reply
		
		! Permit because of task description
		permit ip any any
		
		interface fa0/0.8
		ip access-group NOPING_VLAN_8-VLAN_24 in
		ip access-group NOPING_VLAN_8-VLAN_24 out

! ACL
	! telnet:
		ip access-list extended onlytelnet
			permit tcp host 10.0.1.10 any eq telnet
			deny tcp any any eq telnet
			permit ip any any
		line vty 0 15
			transport input telnet
			access-class notelnet in

	! PC0-PC3 connection:
		ip access-list extended NO_PC0-PC3_CONNECTION
			deny ip host 10.0.1.194 host 10.0.1.66
			deny ip host 10.0.1.66 host 10.0.1.194
			permit ip any any
			
		interface fa0/0.8
			ip access-group NO_PC0-PC3_CONNECTION in
			ip access-group NO_PC0-PC3_CONNECTION out
```

ROUTER1
---

```
en
conf t

! Change
hostname ROUTER1

! Keychain
key chain eigrp_keychain
	key 1
	! the following command is where you give the password:
	key-string ojajnememgy


! interface configurations

	! > Router0
	interface se0/0/0
		no shutdown
		ip address 10.255.0.2 255.255.255.252
		! Auth
		ip authentication mode eigrp 1 md5
		ip authentication key-chain eigrp 1 eigrp_keychain
		! PPP with CHAP
		encapsulation ppp
		ppp chap hostname ROUTER1
		ppp chap password tutilesz
		username Router0 password tutilesz
		

	! > Router2
	interface se0/0/1
		no shutdown
		ip address 10.255.0.5 255.255.255.252
		ip authentication mode eigrp 1 md5
		ip authentication key-chain eigrp 1 eigrp_keychain
		! PPP with CHAP
		encapsulation ppp
		ppp chap hostname ROUTER1
		ppp chap password tutilesz
		username Router2 password tutilesz

	
	! EIGRP
		router eigrp 1
		no auto-summary
			network 10.255.0.2 255.255.255.252
			network 10.255.0.5 255.255.255.252

! ACL
	! telnet:
		ip access-list extended onlytelnet
			permit tcp host 10.0.1.10 any eq telnet
			deny tcp any any eq telnet
			permit ip any any
		line vty 0 15
			transport input telnet
			access-class notelnet in
```

Router2
---

```
en
conf t

! Change
hostname Router2

! Keychain
key chain eigrp_keychain
	key 1
	! the following command is where you give the password:
	key-string ojajnememgy

! interface configurations

	! > ROUTER 1
		interface se0/0/0
			no shutdown
			ip address 10.255.0.6 255.255.255.252
			ip authentication mode eigrp 1 md5
			ip authentication key-chain eigrp 1 eigrp_keychain
			! PPP with CHAP
			encapsulation ppp
			ppp chap hostname Router2
			ppp chap password tutilesz
			username ROUTER1 password tutilesz

	! > Router3
		interface Fa0/1
			no shutdown
			ip address 10.255.0.9 255.255.255.252
			ip authentication mode eigrp 1 md5
			ip authentication key-chain eigrp 1 eigrp_keychain
			
	! > LAN
		interface fa0/0
			no shutdown

		interface fa0/0.24
			encapsulation dot1q 24
			ip address 10.0.1.97 255.255.255.224
			ip helper-address 10.0.1.210

		interface fa0/0.32
			encapsulation dot1q 32
			ip address 10.0.1.1 255.255.255.192
			ip helper-address 10.0.1.210


	! EIGRP
		router eigrp 1
		no auto-summary
		network 10.255.0.6 255.255.255.252
		network 10.255.0.9 255.255.255.252
		network 10.0.1.97 255.255.255.224
		network 10.0.1.1 255.255.255.192
		
! ACL
	! telnet:
		ip access-list extended onlytelnet
			permit tcp host 10.0.1.10 any eq telnet
			deny tcp any any eq telnet
			permit ip any any
		line vty 0 15
			transport input telnet
			access-class notelnet in
```


Rotuer3
---

```
en
conf t

! Change
hostname Router3

! Keychain
key chain eigrp_keychain
	key 1
	! the following command is where you give the password:
	key-string ojajnememgy

! interface configurations

	! > Router2
		interface fa0/0
			no shutdown
			ip address 10.255.0.10 255.255.255.252
			ip authentication mode eigrp 1 md5
			ip authentication key-chain eigrp 1 eigrp_keychain
		

	! > Router4
		interface Eth0/0/0
			no shutdown
			ip address 10.255.0.13 255.255.255.252

	! > LAN
		interface fa0/1
			no shutdown

		interface fa0/1.18
			encapsulation dot1q 18
			ip address 10.0.1.129 255.255.255.224
			ip helper-address 10.0.1.210

	! EIGRP
		router eigrp 1
		redistribute ospf 1 metric 10000 100 255 1 1500
		no auto-summary
		network 10.255.0.10 255.255.255.252


	! OSPF
		router ospf 1
		redistribute eigrp 1 subnets
		no auto-summary
		network 10.255.0.13 255.255.255.252 area 0
		network 10.0.1.129 255.255.255.224 area 0

! ACL
	! telnet:
		ip access-list extended onlytelnet
			permit tcp host 10.0.1.10 any eq telnet
			deny tcp any any eq telnet
			permit ip any any
		line vty 0 15
			transport input telnet
			access-class notelnet in
```

Router4
---

```
en
conf t

! Change
hostname Router4

! interface configurations

	! > Router3
		interface fa0/0
			no shutdown
			ip address 10.255.0.14 255.255.255.252
		

	! > Router5
		interface se0/0/0
			no shutdown
			ip address 10.255.0.17 255.255.255.252
			! PPP with CHAP
			encapsulation ppp
			ppp chap hostname Router4
			ppp chap password tutilesz
			username Router5 password tutilesz

	! > LAN
		interface fa0/1
			no shutdown

		interface fa0/1.26
			encapsulation dot1q 26
			ip address 10.0.1.65 255.255.255.224
			ip helper-address 10.0.1.210

	! OSPF
		router ospf 1
		no auto-summary
		network 10.255.0.14 255.255.255.252 area 0
		network 10.255.0.17 255.255.255.252 area 0
		network 10.0.1.65 255.255.255.224 area 0

! ACL
	! telnet:
		ip access-list extended onlytelnet
			permit tcp host 10.0.1.10 any eq telnet
			deny tcp any any eq telnet
			permit ip any any
		line vty 0 15
			transport input telnet
			access-class notelnet in
```


Router5
---

```
en
conf t

! Change
hostname Router5

! interface configurations

	! > Router4
		interface se0/0/0
			no shutdown
			ip address 10.255.0.18 255.255.255.252
			! PPP with CHAP
			encapsulation ppp
			ppp chap hostname Router5
			ppp chap password tutilesz
			username Router4 password tutilesz
		

	! > Router6
		interface gig0/1
			no shutdown
			ip address 10.255.0.21 255.255.255.252

	! > LAN
		interface gig0/0
			no shutdown

		interface gig0/0.158
			encapsulation dot1q 158
			ip address 10.0.0.1 255.255.255.0
			ip helper-address 10.0.1.210

	! OSPF
		router ospf 1
		redistribute rip subnets
		no auto-summary
		network 10.255.0.18 255.255.255.252 area 0

	! RIP
		router rip
		version 2
		no auto-summary
		redistribute ospf 1 metric 1
		network 10.255.0.21
		network 10.0.0.1
! ACL
	! telnet:
		ip access-list extended onlytelnet
			permit tcp host 10.0.1.10 any eq telnet
			deny tcp any any eq telnet
			permit ip any any
		line vty 0 15
			transport input telnet
			access-class notelnet in
```


Router6
---

```
en
conf t

! Change
hostname Router5

! interface configurations

	! > Router5
		interface Gig0/1
			no shutdown
			ip address 10.255.0.22 255.255.255.252
		
	! > LAN
		interface Gig0/0
			no shutdown

		interface gig0/0
			ip address 10.0.1.209 255.255.255.252

	! RIP
		router rip
		version 2
		no auto-summary
		network 10.255.0.22

! ACL
	! telnet:
		ip access-list extended onlytelnet
			permit tcp host 10.0.1.10 any eq telnet
			deny tcp any any eq telnet
			permit ip any any
		line vty 0 15
			transport input telnet
			access-class notelnet in
```
## Switchek
Switch1
---

```
en
conf t

hostname Switch1

! > Router0
interface fa0/24
	no shut
	sw mode trunk


! > PC4, PC0
interface range fa0/1-2
	no shutdown 
	switchport mode access
	switchport access vlan 8

! > PC2
interface fa0/10
	no shut
	swi mode acc
	sw acc vlan 16
```

Switch0
---

```
en
conf t 

hostname Switch0


! > Router2
interface fa0/1
	no shut
	sw mode trunk

! > Server0
interface fa0/17
	no shutdown
	switchport mode access
	sw acc vlan 24

! > PC3
interface fa0/3
	no shutdown
	switchport mode access
	sw acc vlan 24

! > PC1
interface fa0/2
	no shutdown
	switchport mode access
	sw acc vlan 32
```


Switch2
---

```
en
conf t

hostname Switch2

! > Router3
interface fa0/16
	no shut
	sw mode trunk

! > PC5
interface fa0/19
	no shutdown
	sw mode acc
	sw acc vlan 18

```

Switch3
---

```
en
conf t

hostname Switch3

! > Router4
interface fa0/16
	no shut
	sw mode trunk

! > PC5
interface fa0/19
	no shutdown
	sw mode acc
	sw acc vlan 26

```


Switch4
---

```
en
conf t

hostname Switch4

! > Router5
interface fa0/1
	no shut
	sw mode trunk

! > Switch5
interface fa0/5
	no shutdown
	sw mode trunk

! > PC7
interface fa0/6
	no shutdown
	sw mode acc
	sw acc vlan 158
```

Switch5
---

```
en
conf t

hostname Switch5

! > Switch4
interface fa0/7
	no shut
	sw mode trunk

! > PC8
interface fa0/1
	no shutdown
	sw mode acc
	sw acc vlan 158
```

