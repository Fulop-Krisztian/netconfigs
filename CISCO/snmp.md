# SNMP (v1,v2c,v3) configuration for Cisco IOS devices
In this document you will find a 100% working no scam no lie no cheat 101% work punjabi no virus method to configure SNMP for a cisco device.

Prerequisites
---
- A running SNMP manager which collects the data sent by the devices
- **UDP 161, 162** (for traps) are reachable on both devices (agent and manager)
- Will

Terminology, general knowledge
---
- **Trap** is an unsolicited SNMP message without acknowledgement. The agent sends the update without asking (a little somewhat like the UDP protocol)
- **Inform request** is the opposite. It has acknowledgement, and is solicited. The agent will ask to send the update. (somewhat like TCP)
- An agent (client device) can, but will not by default, send unsolicited updates to the manager

Sources
---
[Cisco's documentation](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/snmp/configuration/xe-16/snmp-xe-16-book/nm-snmp-cfg-snmp-support.html#GUID-C2F92A96-7EB8-4921-8491-46C4D7AD2D49)

## General config (optional)
> [!NOTE]
> It is best practice to set these. The first **snmp-server** setting you enter enables all (supported) versions of SNMP. Anything beyond that is optional.

> [!NOTE]
> Don't be alarmed that the service is called snmp-server. **This is an agent**, but Cisco decided to call it a server. It can't do anything on its own without the snmp manager.

```
enable
configure terminal
! This name can be anything.
snmp-server contact <some name>
! This location can be anything.
snmp-server location <some location>
! This chassis-id can be anything.
snmp-server chassis-id <some random id>
end
! Show the result of what we configured
show snmp
```

> [!NOTE]
> You can turn off the snmp-server if you would like with this command
```
no snmp-server
```

## SNMPv1 & SNMPv2 configuration (Simpler, less serucre, recommended for first try)
First we configure authentication
> [!NOTE]
> These require something referred to as a **community string** to be set up. This is analogous to a **password**, but this community string sounds fancier and more confusing, so it's a perfect name.

> [!NOTE]
> There are two types: Read Only (RO) and Read Write (RW). 
> - **RO** only allows data collection.
> - **RW** allows configuration by the manager as well.

You can configure ACLs too to limit what IPs are allowed.

```
snmp-server community <community-string> <RO/RW> <ACL number (optional)>
```

With this command you are pretty much done. You will now need to configure your manager as well with this string, and everything should work.

### Optional configs
You can enable traps. This will send periodic and triggered unsolicited updates to the snmp manager. 

```
snmp-server host <snmp server IP> traps version <1/2c> <community-string>
```

For traps you can configure what events will trigger an update.

```
! There are others as well I presume, look in the cisco documentation
snmp-server enable traps snmp authentication linkup linkdown coldstart warmstart
```

## SNMPv3 configuration
This is somewhat different from the previous two, but a lot more secure. This is the one you should probably use if you can get it working.

> [!NOTE]
> This version needs users and passwords for authentication. There is also an option for message encryption.
> With these features comes a lot more complexity.

The configuration goes like this:
> [!NOTE]
> By default you have the same permissions as you would with **RW** in v1/2
> You can set up views. These are like the RO/RW permissions for v1/2, but we can configure them more with more granularity. Don't touch them though if you value your sanity



> [!NOTE]
> Second we need to create a **group**.
> It needs an **access type**, which basically configures how secure we want our config to be. There are 3 access types:
> - **noauth**: no authentication and no encryption.
> - **auth**: authentication only (no encryption).
> - **priv**: authentication and encryption
> You can use an ACL too.

```
! Create a group
snmp-server group <groupname> v3 <access-type> access <ACL number (optional)>

! There are 3 access types:
! noauth: No authentication and no encryption.
! auth: Authentication only (no encryption).
! priv: Authentication and encryption
```

> [!NOTE]
> Next we need to create a **user**. The exact data you need to give depends on the access type of the group it will be in.
```
snmp-server user <username> <groupname> v3 auth <auth-protocol> <auth-password> priv <priv-protocol> <priv-password>
! The auth and priv (in other words encryption, but it's referred to as privacy in SNMP) are only required if the group requires it.
```
### Optional configs
You can also configure traps for v3
```
snmp-server host <server ip> version 3 <user>
```

As well as event triggers
```
! There are others as well I presume, look in the cisco documentation
snmp-server enable traps snmp authentication linkup linkdown coldstart warmstart
```

## Minimum working config examples:
Courtesy of ChatGPT

### SNMPv1
```
enable
configure terminal

! Set the community string (analogous to a password)
snmp-server community public RO

! Optionally, you can set a trap host
snmp-server host <trap_host_ip> public
```

### SNMPv2c
```
enable
configure terminal

! Set the community string for SNMPv2c
snmp-server community public RO

! Optionally, set a trap host
snmp-server host <trap_host_ip> public
```

### SNMPv3
```
enable
configure terminal

! Create a group without specifying a view
snmp-server group mygroup v3 priv

! Create a user in the group
snmp-server user myuser mygroup v3 auth sha myauthpassword priv aes myprivpassword
```
