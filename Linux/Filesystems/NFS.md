---
title: Configuring and mounting NFS
tags:
  - linux
  - service
  - desktop
  - etc
---
Terminology, general knowledge
---
- NFS is for sharing folders or entire drives over the network. It literally stands for Network FileSystem
- NFS is similar to [Samba](../Services/Samba.md), but it's more closely integrated with Linux (it's built into the kernel), so its configuration is much, much simpler on Linux than Samba's.
- For regular user shares, consider using Samba. If you want performance, you should use NFS, as it's generally faster (In my experience it's ~10%).

Sources
---
[linuxconfig.org](https://linuxconfig.org/how-to-configure-nfs-on-linux)

Creating a share
---
#### 1. Install the server

Debian and derivatives

```bash
sudo apt install nfs-kernel-server
```

RHEL and derivatives

```bash
sudo dnf install nfs-utils
```

#### 2. Enable the server

```bash
sudo systemctl enable --now nfs-server
```

#### 3. Create the share

In `/etc/exports` (This is the file that describes the NFS shares on a server)

```
<path_to_share>        <allowed_hosts>(<mount_options>)
```

> [!NOTE]
> For the allowed hosts you can use a single hostname (if it's in the `/etc/hosts` file), or you can use an IP range like `10.0.0.0/16` or `2001:db8::/64`

> [!NOTE]  
> For mount options you can use the generic mount options (`man mount`, filesystem-independent mount options section), as well as nfs ones (`man nfs`, mount options section)

For example:

```bash
/media/nfs_share		192.168.1.0/24(rw,sync,no_subtree_check)
```

> [!TIP]
> You can include multiple hosts with different mount options on one line, for example:
> `/media/nfs     192.168.1.112(rw,sync,no_subtree_check) 2001:db8::/64(ro,sync,no_subtree_check)`

#### 4. Load the exports configuration

```bash
sudo exportfs -arv
```

With this your share should now be accessible by clients that you have specified.

Mounting a share
---
#### 1. Install NFS pacakges

Debian and derivatives

```bash
sudo apt install nfs-common
```

RHEL and derivatives

```bash
sudo dnf install nfs-utils
```

#### 2. Mount shares temporarily

```bash
sudo mount -t nfs4  <server_ip>:<path_to_share> <mountpoint>
```

For example:

```bash
sudo mount -t nfs4 192.168.1.110:/media/nfs /media/share
```

#### 3. Mount shares permanently with [fstab](../-%20Configurations/fstab.md)

Append to `/etc/fstab` 

```fstab
192.168.1.110:/media/nfs	/media/share	nfs4	defaults,user,exec	0 0
```


Config examples:
---