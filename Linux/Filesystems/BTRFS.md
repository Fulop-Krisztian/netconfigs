---
title: BTRFS
tags:
  - linux
  - etc
  - desktop
  - todo
---
Terminology, general knowledge
---
- BTRFS is more of an advanced desktop filesystem, though like everything in Linux, it can be (and is) used for anything. For example [Proxmox](../Proxmox/Proxmox.md) offers installation on BTRFS.

Related
---
[Boot out of BTRFS snapshot](../Fixes/Booting.md#Boot%20out%20of%20BTRFS%20snapshot.)

Prerequisites
---
- Time to learn how BTRFS works. It is quite different than "normal" filesystems, such as ext4 or NTFS.
- A working storage device.
- You have the BTRFS utilities installed (`yay -S btrfs-progs` on Arch)

Sources
---

[BTFS wiki](https://btrfs.readthedocs.io/en/latest/Status.html)

[Arch wiki on BTRFS](https://wiki.archlinux.org/title/Btrfs)


Common commands
---

#### Check stats of a filesystem


```bash
btrfs filesystem df <mount_path>
```

Configuration
---



Config examples:
---