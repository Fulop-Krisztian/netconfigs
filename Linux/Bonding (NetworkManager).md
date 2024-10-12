# Linux (NetworkManager) simple interface bonding configuration
This document describes how to configure a bond between different network interfaces with nmcli on Linux


Terminology, general knowledge
---
- A bond is a kind of virtual interface made up of several other interfaces.
- There are different kinds, some are transparent, some require configuration on the connected switch.
- A bonding mode is the a method of how the child interfaces of the bond are utilized. You can find out more about them in the configuration section and in the IBM source.


                


Prerequisites
---
- A linux system with multiple interfaces. **You can mix them.** (For example wlan with Ethernet)
- The linux system is using **NetworkManager** for its networking. (Debian for example)
- You have superuser privileges


Sources
---

> [!TIP]
> These sources are really good. Check them out if something is not clear

[RHEL wiki](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-network-bonding_configuring-and-managing-networking#configuring-network-bonding_configuring-and-managing-networking) for a detailed overview of configuration

[IBM wiki](https://www.ibm.com/docs/en/linux-on-systems?topic=recommendations-bonding-modes) for a detailed description of bonding modes

Configuration
---
> [!CAUTION]
> If possible, don't configure this over the network.
> If you must, put the interface you don't use into the bond first, connect through the bond's IP, and only then put the other interface into the bond. You could also write a script to reset you network that you put on a timer if you want.

### Bonding modes
> [!IMPORTANT]
> For a more detailed description of bonding modes see the IBM wiki in the sources section
> | Bonding Mode | Config requirement
> |---|---|
> | 0 - balance-rr | Requires static EtherChannel enabled, not Link Aggregation Control Protocol (LACP)-negotiated. |
> | 1 - active-backup | No configuration required on the switch. (Recommeded for simple configs. Uses 1 child interface at a time)
> | 2 - balance-xor | Requires static EtherChannel enabled, not LACP-negotiated.
> | 3 - broadcast | Requires static EtherChannel enabled, not LACP-negotiated.
> | 4 - 802.3ad | Requires LACP-negotiated EtherChannel enabled.
> | 5 - balance-tlb | No configuration required on the switch. (Should generally perform better for transmission than active backup, may perform worse)
> | 6 - balance-alb | No configuration required on the switch. (Should generally perform better than active backup, may perform worse)

> [!TIP]
> Some details for the three modes that don't require a managed switch (Those methods will always be the best)
>| Feature                     | Active-Backup (Mode 1) | Balance-TLB (Mode 5)        | Balance-ALB (Mode 6)        |
>|-----------------------------|------------------------|-----------------------------|-----------------------------|
>| **Outgoing Traffic**        | Single interface active| Load balanced across slaves | Load balanced across slaves  |
>| **Incoming Traffic**        | Single interface active| Single interface active     | Load balanced across slaves   |
>| **Failover Capability**     | Yes                    | Yes                         | Yes                         |
>| **Complexity**              | Low                    | Medium                      | Very high. Balances with ARP.                      |
>| **Performance**             | Moderate               | Improved transmission       | Improved                       |
>| **Verdict**                 | Use for first try      | Balanced choice             | Best if the network is ready       |


### Configuration start
> [!NOTE]  
> Create the bond interface. We will add the child interfaces later.

```
nmcli connection add type bond con-name <connection_name> ifname <interface_name> bond.options "mode=<bond_mode>"
```

> [!NOTE]  
> List the connections that you would like to add to the bond

```
mcli device status
```


> [!NOTE]  
> Place the connection(s) inside the bond and restart said connection
> **Use the name in the connection row**

> [!WARNING]  
> If you are configuring over the network, here is where you should connect to the bond after it gets its first interface.


if the interfaces you want to use completely unconfigured, see the RHEL wiki in the sources section

```
nmcli connection modify <connection_name> master <bond_name>
nmcli connection up <connection_name>
# If you are connecting over the network 
```

If you want you can make one of the interfaces the primary (when using active-backup)

```
sudo nmcli con modify <bond_name> +bond.options "primary=<interface_name>"
```

Minimum working config examples:
---

This is a config example for a Raspberry Pi 4. We bond the eth0 and wlan to have a constant connection.
```
sudo nmcli connection add type bond con-name bond0 ifname bond0 bond.options "mode=active-backup"
sudo nmcli connection modify WifiName master bond0
sudo nmcli connection up WifiName
# !!! At this point the bond should be working, and you should switch the remote connection (if you are using that) over to it.
sudo nmcli connection modify Wired\ connection\ 1 master bond0
sudo nmcli connection up Wired\ connection\ 1

# With this you are finished. You should now set a static IP for the bond, or leave it as DHCP. Be aware that if you leave it on DHCP the bond will use the mac of the currently active interface for the request, thus YOU WILL NOT BE ABLE TO USE RESERVATIONS
```


Some testing (unfinished, and irrelevant):
---
I can't fully do these tests, since the single ethernet port of the RPI saturates my bandwidth (even with iperf in lan. It can reach 939 Mbits/sec)

This is a small test with my raspberry PI. I used ookla's speedtest on the terminal to test my connection speed with two configurations:

(full speed internet connection is about 800/315 Mbps with ~6ms latency for reference)

Failover with the wireless interface running only:
Idle Latency: 7.12 ms

Download speed: 107.44 Mbps
Download latency: 29.14 ms

Upload speed: 110.64 Mbps
Upload latency: 23.82 ms


Failover with the Ethernet interface running only:
Idle Latency: 6.01 ms
Download speed: 776.22 Mbps
Download latency: 6.47 ms

Upload speed: 322.66 Mbps
Upload latency: 6.01 ms 