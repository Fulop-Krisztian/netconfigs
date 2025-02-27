# Firmware update
created: 2025-02-27 14:25
tags: #basic #router #switch #firmware #cisco 

## Preparation

- You should already have an image you want to install, you can find some in the [Sources](#Sources) section. You should probably find out [what you are installing](Firmware%20types.md) 

#### tftp transfer
- You have to use a TFTP server
	- For Windows [tftpd](https://bitbucket.org/phjounin/tftpd64/downloads/) is recommended. (Portable downloads included)
		- Just place the image in the root folder, and select the interface
	- For Linux use [tftpd-hpa](https://www.baeldung.com/linux/tftp-server-install-configure-test)
- You need to configure the server and the Cisco device to be able to ping (reach) each other
#### Serial transfer
- In some cases, like when recovering on older switches, you may need a serial connection along with a program capable of XMODEM file transfer over serial.
	- For Windows I recommend [TeraTerm](https://teratermproject.github.io/index-en.html)
	- For Linux I recommend [CuteCom](https://cutecom.sourceforge.net/) for GUI, or [minicom](https://www.man7.org/linux/man-pages/man1/minicom.1.html) and [lrzsz](https://ohse.de/uwe/software/lrzsz.html) package for a terminal utility. [Linux terminal serial connections](../../Linux/Command%20compendium.md#Serial%20connections)

> [!CAUTION]  
> I advise against using **ExtraPutty**, as it doesn't consistently detect transmission errors, and could waste a lot of your time by apparently transferring a file, but not actually transferring it.
> It is good for everything else else besides serial file transfer however.

Sources
---
### Images
https://archive.org/download/cIOS-firmware-images/

### Information
[Cisco C3550 rommon serial image update](https://www.cisco.com/c/en/us/support/docs/switches/catalyst-3550-series-switches/41541-190.html)
Hands on experience with a C3550

## Updating

From Within IOS
---

> [!TIP]  
> You will be operating with the filesystem of the Cisco device. The command to list a directory is
> `dir flash:<directory>`
#### 1. Delete current image (optional):

If you don't have enough space, you can remove the image that is currently running.

> [!CAUTION]
> You can't reboot after this, or you will end up having to [recover from rommon](#From%20rommon%20(recovery%20without%20existing%20image))

```IOS
delete /force /recursive flash:<folder_name>
```

#### 2. Copy over the new file:

You'll copy the file from the [tftp](#tftp%20transfer) server that you've set up in the preparation phase
##### a) If the file is a tar file:

```IOS
archive download-sw /overwrite tftp://<tftp_ip>/<tar_filenam>
```
##### b) If the file is a bin file:
```IOS
copy tftp:<image_name> flash:<image_name>
```

#### 3. Set the new boot image

> [!TIP]  
> You don't need to do this if you copied with `archive download-sw`

```
enable
configure terminal
boot system flash:<system_image_binary_path>
```

#### 4. Reboot

All that remains now is for you to reboot into the newly copied image

```IOS
reload
```

From rommon (recovery without existing image)
---
Your image got corrupted, or you just deleted it to make space for a new image, which doesn't boot. It happens.

This guide will focus on transferring via a serial connection in rommon so that you can get a booting image at least.

> [!TIP]
> I recommend using the smallest image you can find, even if it is very old
> 
> Serial under the best configurations can still take up to 30 minutes for a 7MB file transfer on some devices
> 
> When you have the image on there, you can use the tftp method which is way faster

TODO

[Serial transfer](#Serial%20transfer)

Copy image over XMODEM, don't set serial speed to high because it can cause issues even if you don't see it in terminal operation.

