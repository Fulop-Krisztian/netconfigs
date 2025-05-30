---
title: Remove NTFS dirty label
tags:
  - linux
  - windows
  - desktop
  - fix
---
Terminology, general knowledge
---
- Sometimes you might get a dirtly label on your NTFS partitions in Linux, and depending on your [fstab](../-%20Configurations/fstab.md) configuration, you might fail to boot
- You should run [CHKDSK](../../Windows/CHKDSK.md) periodically if you use the NTFS partition in Linux regularly (Like using it as a C drive in Wine)

Configuration
---
> [!WARNING]  
> This command only removes the dirty label. If there's something actually wrong with the partition, this might make it worse by forcing it to operate with issues (unlikely). 
> 
> If you suspect that something is really wrong with the drive, you should run a [Windows CHKDSK](../../Windows/CHKDSK.md) on it

```bash
ntfsfix -d /dev/<partition>
```

Alternatives
---
You might consider modifying your NTFS partitions' [fstab](../-%20Configurations/fstab.md) entry so that they don't stop your system from booting by changing the numbers at the end of the entry to `0 0`, and adding the `force` option.

For example:
```fstab
UUID=DAC40F33C40F1205   /run/media/krissssz/DAC40F33C40F1205    ntfs3           force,rw,nosuid,nodev,relatime,uid=1000,gid=1001,iocharset=utf8       0 0
```
