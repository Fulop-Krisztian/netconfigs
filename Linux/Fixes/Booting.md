---
title: Booting
tags:
  - linux
  - basic
  - etc
  - desktop
  - fix
---
Common issues that may arise when trying to boot, such as the boot entry not being present in BIOS.

## [NTFS dirty label preventing boot](Remove%20NTFS%20dirty%20label.md#Alternatives)

## Boot entry not present

This might happen if you update your Windows system or BIOS when dual-booting Windows and Linux. In this case it has probably not been deleted, you can still boot via [ventoy](https://www.ventoy.net/en/index.html)

To fix the issue itself, first run 

```bash
sudo efibootmgr
```

to see if the entry is truly not present. If it is and it still doesn’t show, it might be.

Next to try is:

```bash
sudo grub-install
```

followed by [remaking the grub config](#Remake%20grub%20config)

Next to try if the last one didn't work:

```bash
sudo efibootmgr -c -L "EndeavourOS" -l '\EFI\endeavouros\grubx64.efi'
```

> [!NOTE]  
> This is for endeavouros, you should explore the `/boot/efi/EFI` directory and see what kind of OSs you can find. You can create a boot entry for each of them manually using the command.

## Remake grub config

You can remake the grub config with this command:

**For Arch and derivatives:**

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

> [!WARNING]  
> This might be different for your distribution


## Rebuild initramfs

You can rebuild the initramfs on Endeavouros with this command:

`sudo dracut-rebuild

## Boot out of BTRFS snapshot.

- Go into grub
- press e
- delete the snapshot part of the 3 paths until the ‘@’
- boot into that
- [remake the grub config](#Remake%20grub%20config)
