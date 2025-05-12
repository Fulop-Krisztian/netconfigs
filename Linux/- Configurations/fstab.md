---
title: Linux fstab file
tags:
  - linux
  - etc
  - desktop
  - todo
---
Terminology, general knowledge
---
- With fstab, you can specify all sorts of filesystems to be mounted on boot.. These include but are not limited to:
	- Regular partitions
	- Swap partitions
	- ISO Images
	- sshfs file systems (If you have ssh access to a machine, you can mount it as a filesystem on boot)
	- Network file systems like cifs/samba and nfs
	- Cloud storage drives like [Proton Drive](https://rclone.org/protondrive/) and [Google Drive](https://rclone.org/drive/) (if you don't know how to, [rclone](https://rclone.org/docs/) docs are a good place to start)
	- Basically anything you could mount with the regular `mount` command

> [!WARNING]  
> By default if [Systemd](../Services/systemd/Systemd.md) can't mount something, it panics and doesn't continue the boot. If you mess up an entry in fstab, you might not be able to boot your system


Prerequisites
---
- Working Linux install. Other than that fstab is default for all distributions

Sources
---
[Arch wiki: Genfstab](https://wiki.archlinux.org/title/Genfstab)

[Arch wiki: Identifying filesystems for fstab](https://wiki.archlinux.org/title/Fstab#Identifying_file_systems)

Configuration
---

### Manually with lsblk

First we need to find out some things about the disk we're trying to mount

```bash
lsblk -f
```

Output should look something like this:

```bash
NAME FSTYPE FSVER LABEL UUID            FSAVAIL FSUSE% MOUNTPOINTS  

nvme0n1p3 ntfs         EE5A55685A552F19 14,4G   85%    /run/media/krissssz/mnt  
```

> [!NOTE]  
> You will need the **UUID** (which can look different depending on the file system type) and the **mountpoint**. Also you will need to mount it with settings appropriate for 

Next input these into fstab. Depending on your partition choose from the [Minimum working config examples](#Minimum%20working%20config%20examples)

### Manually with genfstab

- Download genfstab  ̇`yay -S genfstab ̇`
- `genfstab -U /`
- copy output into `/etc/fstab`
- delete what you don’t need
- done.

###


Config examples
---

These config examples are not minimal, and include additional configurations. You should consult each file system's mount option documentation for more information about them
#### NTFS partition

[mount option docs for ntfs-3g](https://linux.die.net/man/8/mount.ntfs-3g)

> [!WARNING]  
> Make sure that the uid and the gid match the user you use.
> (you can find out your uid and gid with the `id` command)

> [!CAUTION]
> We are using the `force` option

```fstab
UUID=<UUID> <mount_path (eg. /mnt or /run/media/user/mount1)>   ntfs3 force,rw,nosuid,nodev,relatime,uid=1000,gid=1000,iocharset=utf8,windows_names,auto 0 0
```

#### BTRFS partition

[Mount options specific to BTRFS](https://btrfs.readthedocs.io/en/latest/ch-mount-options.html)

```fstab
UUID=<UUID> <mount_path>  btrfs   subvol=<subvolume>,rw,nossd,compress-force=zstd:4,autodefrag,auto  0 0
```


