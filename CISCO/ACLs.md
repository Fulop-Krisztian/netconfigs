# ACL configuration

Terminology, general knowledge
---
- Access Control List. It controls access.
- Filtering goes from most specific to least specific
- Placed on incoming or outgoing interfaces. Also some services support ACL filtering (like SSH or SNMP)
- By default everything is denied

Types
---

> [!NOTE]
> There are 3 types:
> - Standard
> - Extended
> - Named (which can be standard or extended)

cisco recommendation is that we configure:
- Standard: Closest to destination
- Extended: Closest to source

> [!TIP]
>  Don't listen to the recommendations


Configuration

> [!NOTE]
> - Too long ACLs can impact performance
>- Don't replace firewalls with ACLs.

---
For each type you should get acquainted with the network first. Then think about where the best place would be to filter, and only then write the configuration.

### Standard
```
access-list (1-99) (permit/deny/remark) (IP)
```


### Extended
```
access-list (100-199) (permit/deny/remark) (protocol) (source_host) (matching method and arguement) (destination_host) (matching method and arguement)
```

### Named
```
ip access-list <extended/standard> <acl_name>
! you will now be put into the acl configuration mode
<line number> <extended or standard configuration>
```

#### Examples:

##### permit any host that wants to reach 10.0.0.5 on tcp port 80. Deny all else.
```
access-list 120 permit tcp any host 10.0.0.5 eq 80
```

#### deny any host access to a whole subnet with the given ports
```
access-list 112 deny tcp any 172.16.0.0 0.0.255.255 eq 443
access-list 112 deny tcp any 172.16.0.0 0.0.255.255 eq 80
access-list 112 deny tcp any 172.16.0.0 0.0.255.255 eq 21
access-list 112 permit ip any any 
interface ethernet0/0/0
ip access-group 112 out
```

##### permit only a single pc to reach routers on telnet
```
ip access-list standard notelnet
permit 192.168.0.2
exit
line vty 0 15
access-class notelnet in
```

## Applying to interface
```
interface <interface>
ip access-group <ACL> <in/out>
```

## Applying to vty 
```
line vty 0 15
ip access-class 
```

