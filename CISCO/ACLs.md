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

#### Examples:
```
! permit any host that wants to reach 10.0.0.5 on tcp port 80. Deny all else.
access-list 120 permit tcp any host 10.0.0.5 eq 80
```


## Applying to interface
```
interface <interface>
ip access-group <ACL> <in/out>
```