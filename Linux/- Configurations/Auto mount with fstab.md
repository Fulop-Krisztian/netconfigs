---
title: Auto mount with fstab
tags:
  - linux
  - etc
  - desktop
  - todo
---
Terminology, general knowledge
---


Prerequisites
---


Sources
---
> [!info] genfstab - ArchWiki  
>  
> [https://wiki.archlinux.org/title/Genfstab](https://wiki.archlinux.org/title/Genfstab)  

> [!info] fstab - ArchWiki  
>  
> [https://wiki.archlinux.org/title/Fstab#Identifying_file_systems](https://wiki.archlinux.org/title/Fstab#Identifying_file_systems)  

Configuration
---

### Manually with lsblk

First we need to find out some things about the disk we're trying to mount

```bash
lsblk -f
```

Output should look something like this:

```bash
krissssz@krissssz-pc ~> lsblk -f  
NAME FSTYPE FSVER LABEL UUID             FSAVAIL FSUSE% MOUNTPOINTS  

├─nvme0n1p3 ntfs        EE5A55685A552F19 14,4G   85%    /run/media/krissssz/mnt  
```

> [!NOTE]  
> You will need the **UUID** and the **mountpoint**. Also you will need to mount it with settings appropriate for 

Next input these into fstab. Depending on your partition choose from the [Minimum working config examples](#Minimum%20working%20config%20examples)

### Manually with genfstab

- Download genfstab  ̇`yay -S genfstab ̇`
- `genfstab -U /`
- copy output into `/etc/fstab`
- delete what you don’t need
- done.

###


Minimum working config examples
---
NTFS partition
```fstab
UUID=<UUID> <mount_path (eg. /mnt or /run/media/user/mount1)>   ntfs3 force,rw,nosuid,nodev,relatime,uid=1000,gid=1001,iocharset=utf8,windows_names,auto 0 0
```

BTRFS partition

```fstab
UUID=<UUID> <mount_path>  btrfs   subvol=/,rw,nossd,compress-force=zstd:4,autodefrag,auto  0 0
```


