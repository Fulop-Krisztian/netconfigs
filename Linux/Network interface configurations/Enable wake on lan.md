> [!INFO] How to Enable Wake-on-LAN in Ubuntu 22.04? [SOLVED] | GoLinuxCloud  
> In this article we will tell you how to enable Wake-on-LAN in Ubuntu and example usage.  
> [https://www.golinuxcloud.com/wake-on-lan-ubuntu/](https://www.golinuxcloud.com/wake-on-lan-ubuntu/)  

`sudo ethtool <interface>`

if the Wake-on is d, it is disabled but supported

`sudo ethtool -s <interface> wol g`