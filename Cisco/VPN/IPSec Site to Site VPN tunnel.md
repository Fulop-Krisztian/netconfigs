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
https://www.cisco.com/c/en/us/support/docs/security-vpn/ipsec-negotiation-ike-protocols/41940-dmvpn.html
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

#### Working DMVPN Site-to-site VPN, without IPsec
##### HUB

```

! Required preexisting configuration
! (LAN, WAN, NAT)
	
	! > LAN
	interface gig0/0
		ip address 10.0.0.0 255.255.255.0
		ip nat inside
		no shutdown
	
	! > WAN
	interface gig0/1
		ip address 82.136.79.1 255.255.255.252
		ip nat outside
		no shutdown
	
	! NAT: LAN > WAN
		ip access-list standard NAT-ACL
			permit 10.0.0.0 0.0.0.255
		ip nat source list NAT-ACL interface gig0/1 overload 


! (You could use static routes, routing into the tunnel subnet)
! IPv4 EIGRP Configuration
	router eigrp 100
		network 10.0.0.0 0.0.0.255
		no auto-summary

	    passive-interface default
	    no passive-interface gig0/0
	    
	    ! Tunnel config
	    network 192.168.0.0 0.0.0.255
	    no passive-interface tunnel0


! Site to site VPN configuration
	! GRE tunnel
		interface tunnel0
			! You MUST give a no shutdown command !
			no shutdown 
			
			! Public IP
			tunnel source 82.136.79.1
			
			! Multipoint GRE for multiple site connection
			tunnel mode gre multipoint
			
			! IP for inter tunnel communication
			! This can be whatever you want it to be, it doesn't really matter, just make sure it doesn't overlap with anything
			ip address 192.168.0.1 255.255.255.0
			
			! These are required for EIGRP to work correctly over the tunnel
			! These options are specific to this interface
			no ip next-hop-self eigrp 100
		    no ip split-horizon eigrp 100

			! NHRP configuration
				! Must match on all sites
				ip nhrp network-id 1
				
				! Tunnel key (must match on all sites, but different between routers using the same site)
				tunnel key 123
				
				! Password authentication (8 char limit)
				ip nhrp authentication Password
				
				! Allow multicast traffic over the tunnel interfaces (only set this on the HUB routers)
				ip nhrp map multicast dynamic

```
##### Spoke (similar for all spokes)

```
!!! What you must change between sites is specified in the DMVPN configuration section.

! Required preexisting configuration
! (LAN, WAN, NAT)
	
	! > LAN
	interface gig0/0
		ip address 10.1.0.0 255.255.255.0
		ip nat inside
		no shutdown
	
	! > WAN
	interface gig0/1
		ip address 82.136.79.5 255.255.255.252
		ip nat outside
		no shutdown
	
	! NAT: LAN > WAN
		ip access-list standard NAT-ACL
			permit 10.1.0.0 0.0.0.255
		ip nat source list NAT-ACL interface gig0/1 overload 



! IPv4 EIGRP Configuration
	router eigrp 100
	    network 10.1.0.0 0.0.0.255
	    
		no auto-summary
	    passive-interface default
	    ! EIGRP for tunnel configuration
		    network 192.168.0.0 0.0.0.255
		    no passive-interface tunnel0


! Site to site VPN configuration
	! GRE tunnel
		interface tunnel0
			no shutdown
			
			! Public IP
			! This changes for each site !!!
			tunnel source 82.136.79.5
			
			! Multipoint GRE for multiple site connection
			tunnel mode gre multipoint
			
			! IP for inter tunnel communication
			! This changes for each site !!!
			ip address 192.168.0.2 255.255.255.0
			
			! NHRP configuration
				! NHRP for dynamic inter-site communication (must match on all sites)
				ip nhrp network-id 1
				
				! Tunnel key (must match on all sites, but different between routers using the same site)
				tunnel key 123
				
				! Password authentication (8 char limit)
				ip nhrp authentication Password

				! Allow multicast traffic over the tunnel interfaces (this is the same for all sites)
				ip nhrp map multicast 82.136.79.1
				ip nhrp map 192.168.0.1 82.136.79.1
				ip nhrp nhs 192.168.0.1
```

You would also need an ISP, In the real world, you would not be the one configuring this

```
! ISP

	! > HUB
	interface gig0/0
		ip address 82.136.79.2 255.255.255.252
		no shutdown


	! > SPOKE
	interface gig0/1
		ip address 82.136.79.6 255.255.255.252
		no shutdown
```



















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
