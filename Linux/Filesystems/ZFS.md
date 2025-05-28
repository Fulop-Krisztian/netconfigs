---
title: ZFS pool creation and management
tags:
  - linux
  - etc
---
Terminology, general knowledge
---
![](../../-%20Attachments/Pasted%20image%2020250527195155.png)

- There are two ways you can use the ZPOOL:
	- **Datasets**: These are analogous to partitions. You can mount them, you can set different mount options, checksums,
	- **ZVOLS**: These are analogous to block devices (disks). You can format them as if they were an independent disk, you can put any other file system on it.

Prerequisites
---


Sources
---
[Proxmox wiki](https://pve.proxmox.com/wiki/ZFS_on_Linux)

[Snapshots in more detail](https://www.thegeeksearch.com/beginners-guide-to-zfs-snapshots/)
Pool creation
---

First, create a ZFS pool

```bash
zpool create -f -o ashift=12 <pool_name> raidz1 <device1> <device2> <device3>
```

> [!TIP] 
> (2^`ashift` should the biggest sector size among your drives (It's commonly 4096 bytes, so 2^12). 
> 
> You can check sector sizes with `smartctl -a /dev/sda | grep "Sector Size"`)

Next you should limit ARC memory usage (8GB in example) 

In `/etc/modprobe.d/zfs.conf` enter:

```conf
options zfs zfs_arc_max=8589934592
```

Update your initramfs to apply the changes (for systems with initramfs): 

```bash
update-initramfs -u -k all
```

> You may need to use other tools on other systems. For example EndeavourOS comes with Dracut by default.

> [!TIP]
> You can check the status of your newly created pool with `zpool status <pool_name>`

Configuration
---

> [!TIP]
> When datastore is referenced in the below configuration options, you can use the pool name to configure the option for the whole pool.
#### Change pool mountpoint

> [!TIP]
> You can easily check all mountpoints with `zfs list`

```bash
zfs set mountpoint=<mount_path> <pool_name>
```

#### Create dataset

```bash
zfs create <pool_name>/<dataset_path>
# For example: zfs create tank/dataset1
```

#### Enable compression

This is a no-brainer. No real reason not to enable this for standard use cases.

```bash
zfs set compression=<algorithm> <datatore>
```

( The `lz4` algorithm is a good default)
#### Enable deduplication

> [!NOTE]  
> A lot of places say that deduplication is not really worth it in most use cases. You should do some research before you enable this.

```bash
zfs set dedup=on <datastore>
```

#### Disable access time

Disabling access time saves a lot of writing (otherwise every read would result in a write, which isn't too efficient)

```bash
zfs set atime=off <datastore>
```

#### Enable periodic scrubbing

Debian comes with default [Systemd](../Services/systemd/Systemd.md) timers, but you have to enable those for the pools you create

monthly:

```bash
# monthly scrub
systemctl enable zfs-scrub@<pool_name>.timer
systemctl start  zfs-scrub@<pool_name>.timer
```

weekly:

```bash
# weekly scrub
systemctl enable zfs-scrub-weekly@<pool_name>.timer
systemctl start  zfs-scrub-weekly@<pool_name>.timer
```

#### Creating and managing snapshots

Snapshot naming convention is: `pool/datastore@something`. For something you should probably use a date, like `zfs snapshot pool/filesystem@thursday`

##### Create

```
zfs snapshot pool/filesystem@thursday
```

##### Rollback

You don't need to specify anything else other than the snapshot.

```
zfs rollback pool/filesystem@thursday
```