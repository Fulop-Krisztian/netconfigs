# Firmware update
created: 2025-02-27 14:25
tags: #basic #router #switch #firmware #cisco 
Terminology, general knowledge
---


Prerequisites
---


Sources
---
https://archive.org/download/cIOS-firmware-images/


Configuration
---



#### Delete current image:

`delete /force /recursive <folder_name>`

#### Copy over the new file:


##### Tar:
`archive download-sw /overwrite tftp://<tftp_ip>/<tar_filenam>`


> [!NOTE]  
> Find the boot image that you copied over, it's usually in a folder named the same as the tar
> `dir flash:<directory>`



```
en
conf t
boot system <system_binary>
```
Minimum working config examples:
---