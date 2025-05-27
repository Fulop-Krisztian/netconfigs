
https://www.golinuxcloud.com/wake-on-lan-ubuntu/  

First and foremost you should enable Wake on LAN in the BIOS. It differs between vendors. Best places to look are energy saving settings, and network configuration.

`sudo ethtool <interface>`

if the `Wake-on` is `d`, wake on lan is disabled, but otherwise supported.

To enable it:
`sudo ethtool -s <interface> wol g`