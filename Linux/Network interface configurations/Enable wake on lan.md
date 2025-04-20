> [!INFO] How to Enable Wake-on-LAN in Ubuntu 22.04? [SOLVED] | GoLinuxCloud  
> In this article we will tell you how to enable Wake-on-LAN in Ubuntu and example usage.  
> [https://www.golinuxcloud.com/wake-on-lan-ubuntu/](https://www.golinuxcloud.com/wake-on-lan-ubuntu/)  

First and foremost you should enable Wake on LAN in the BIOS. It differs between vendors. Best places to look are energy saving settings, and network configuration.

`sudo ethtool <interface>`

if the `Wake-on` is `d`, wake on lan is disabled, but otherwise supported.

To enable it:
`sudo ethtool -s <interface> wol g`