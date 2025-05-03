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

### Manually with genfstab

- Download genfstab  ̇`yay -S genfstab ̇`
- `genfstab -U /`
- copy output into `/etc/fstab`
- delete what you don’t need
- done.

###


Minimum working config examples:
---





