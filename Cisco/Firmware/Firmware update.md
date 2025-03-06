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
- You need to configure the server (your PC) and the Cisco device to be able to ping (reach) each other. (A quick method is using APIPA on the PC and setting one from the APIPA subnet on the device.)
#### Serial transfer
- In some cases, like when recovering on older switches, you may need a serial connection along with a program capable of XMODEM file transfer over serial.
	- For Windows I recommend [TeraTerm](https://teratermproject.github.io/index-en.html)
	- For Linux I recommend [CuteCom](https://cutecom.sourceforge.net/) for GUI, or [minicom](https://www.man7.org/linux/man-pages/man1/minicom.1.html) and [lrzsz](https://ohse.de/uwe/software/lrzsz.html) package for a terminal utility. [Linux terminal serial connections](../../Linux/Command%20compendium.md#Serial%20connections)

> [!CAUTION]  
> I advise against using **ExtraPutty**, as it doesn't consistently detect transmission errors, and could waste a lot of your time by apparently transferring a file, but not actually transferring it.
> It is good for everything else else *besides* serial file transfer however.

Sources
---
### Firmware images
https://archive.org/download/cIOS-firmware-images/

### Information
[Cisco C3550 rommon serial image update](https://www.cisco.com/c/en/us/support/docs/switches/catalyst-3550-series-switches/41541-190.html)
Hands on experience with a C3550

## Updating

From Within IOS
---

> [!TIP]  How to list current files
> You will be operating with the filesystem of the Cisco device. The command to list a directory is
> `dir flash:<directory>`
#### 1. Delete current image (optional):

If you don't have enough space, you can remove the image that is currently running.

> [!CAUTION] Don't reboot
> You can't reboot after this, or you will end up having to [recover from rommon](#From%20rommon%20(recovery%20without%20existing%20image))

```IOS
delete /force /recursive flash:<folder_name>
```


#### 2. Copy over the new file:

You'll copy the file from the [tftp](#tftp%20transfer) server that you've set up in the preparation phase
##### a) If the file is a tar file:

 The extraction of the .tar archive happens in ram, so you don't need additional space to hold the arhive while it's extracting

> [!NOTE] Website
> This copies over the management website files as well automatically.

 
```IOS
archive download-sw /overwrite tftp://<tftp_ip>/<tar_filenam>
```
##### b) If the file is a bin file:
```IOS
copy tftp:<image_name> flash:<image_name>
```

#### 3. Set the new boot image

> [!TIP]  Skip if...
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

This guide will focus on transferring via a serial connection in rommon so that you can get a booting image at least. This should work for all Cisco devices, as this is the simplest (and slowest) way of transferring a file to a device.

> [!TIP] Use small images for serial transfer
> I recommend using the smallest image you can find, even if it is very old
> 
> Serial, even under the best configurations, can still take up to 30 minutes for a 7MB file transfer on some devices
> 
> When you have the image on there, you can use the tftp method to copy over an image (or a full .tar archive with the management website as well) which is way faster

> [!IMPORTANT]  Copying with TFTP
> You might be able to copy files via TFTP over rommon, most modern devices will allow this. That would be much faster than a serial connection, so I recommend that.

TODO

#### 1. Get into rommon

If your image doesn't boot at all, this is where you'll end up automatically.

Otherwise you should look up how to get into your device. Common methods include:
- Holding down the mode button on a switch while you connect it to power

[Serial transfer](#Serial%20transfer)



Copy image over XMODEM, don't set serial speed to high because it can cause issues even if you don't see it in terminal operation.

