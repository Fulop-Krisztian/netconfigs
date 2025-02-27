# Firmware update
created: 2025-02-27 14:25
tags: #basic #router #switch #firmware #cisco 
Terminology, general knowledge
---


Prerequisites
---
- You already have an image you want to install, you can find some in the [Sources](#Sources) section 
- You have a TFTP server where relevant
	- For Windows [tftpd](https://bitbucket.org/phjounin/tftpd64/downloads/) is recommended. (Portable downloads included)
	- For Linux use [tftpd-hpa](https://www.baeldung.com/linux/tftp-server-install-configure-test)
- In some cases (like when recovering on older switches), you may need a serial connection along with a program capable of XMODEM file transfer over serial.
	- For Windows I recommend [TeraTerm](https://teratermproject.github.io/index-en.html)
	- For Linux I recommend [CuteCom](https://cutecom.sourceforge.net/) for GUI, and the [lrzsz](https://ohse.de/uwe/software/lrzsz.html) package for a terminal utility. 


- Once you have `lrzsz` installed, you can initiate file transfers using commands like:
	- To **send a file** via XMODEM:
	    `sx file-to-send /dev/ttyUSB0`
	- To **receive a file** via XMODEM:
	    `rx file-to-receive /dev/ttyUSB0`



> [!CAUTION]  
> I advise against using **ExtraPutty**, as it doesn't consistently detect transmission errors, and could waste a lot of your time by apparently transferring a file, but not actually transferring it.

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