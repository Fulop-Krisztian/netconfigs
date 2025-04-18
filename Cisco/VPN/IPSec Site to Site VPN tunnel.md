# IPsec Site-to-Site VPN tunnel with GRE on Cisco devices

#cisco  #router  #vpn 

Terminology, general knowledge
---
IPsec: For the packet's encryption, integrity and security. It's a framework which allows different technologies to be substituted into it.

![IPsec Image 1](../../-%20Attachments/IPsec/IPsec%20modularity.png)
![IPsec Image 2](../../-%20Attachments/IPsec/IPsec%20modularity%20example.png)

GRE: Encapsulates the packet in an IP packet. This allows transportation of the encaplsulated packet to another GRE endpoint
An IPSec and GRE tunnel VPN looks something like this:
![GRE encapsulation](../../-%20Attachments/IPsec/IPsec%20and%20GRE%20tunnel.png)
Encapsulation would look something like this:
IPsec(GRE tunnel(Original IP packet(Data)))

Prerequisites
---


Sources
---
https://www.youtube.com/watch?v=C_B9k0l6kEs
https://www.youtube.com/watch?v=68Raa0FWNkg
Netacad CCNA module 8

Configuration
---






```
crypto isakmp policy 1
encryption aes
hash sha
authentication pre-share
group 2
exit


crypto isakmp key <password> address <remote_address> 
crypto ipsec transform-set <setname> esp-aes esp-sha-hmac

exit

! from - to
access list 100 permit ip 10.0.0.0 0.255.255.255  192.168.1.0 0.0.0.255

cryptomap map <name_you_set> 1 ipsec-isakmp
set transform-set <setname>
set peer <remote_address>
match address 100
exit

! Apply this crypto map to an interface
interface <outside interface>
crypto map <setname>

! You should now get a message saying that it's on.

show crypto map



Peer:
! Define ISAKMP policy
crypto isakmp policy 1
 encryption aes
 hash sha
 authentication pre-share
 group 2
 exit

! Define the pre-shared key for the local peer
crypto isakmp key <password> address <local_address>

! Define the IPSec transform set
crypto ipsec transform-set <setname> esp-aes esp-sha-hmac

! Define the access list for interesting traffic
access-list 100 permit ip 192.168.1.0 0.0.0.255 10.0.0.0 0.255.255.255

! Define the crypto map
crypto map map <name_you_set> 1 ipsec-isakmp
 set transform-set <setname>
 set peer <local_address>
 match address 100
 exit

! Apply the crypto map to the outside interface
interface <outside interface>
 crypto map <name_you_set>

```

Minimum working config examples:
---


```
en
conf t
hostname R1
interface gig0/0
no shut
ip nat inside
ip address 10.0.0.1
exit
interface gig0/1
no shut
ip nat outside
ip address 1.1.1.1
exit

ip nat pool POOL1

```
