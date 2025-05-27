---
title: GameMode configuration
tags:
  - linux
  - desktop
  - gaming
---
Terminology, general knowledge
---
- Gamamode optimizes small things related to gaming on your system, like CPU governor configuration, niceness of launched games, and some other things.
- Works best on laptops and on systems where there are background tasks (like a video player or a communication platform)

Sources
---
[Arch wiki](https://wiki.archlinux.org/title/GameMode)

[Relevant reddit post](https://www.reddit.com/r/linux_gaming/comments/1kjer3k/psa_your_gamemode_might_be_configured_incorrectly/)

[GameMode GitHub](https://github.com/FeralInteractive/gamemode)

Prerequisites
---
- Install GameMode with 32-bit support (`yay -S gamemode lib32-gamemode`)
- VERY IMPORTANT:

> [!IMPORTANT]  
> You need to add yourself to the gamemode group:
> `sudo usermod -aG gamemode`
> Otherwise gamemode won't have the permissions to modify your system for best performance
> You can test whether gamemode is functioning with:
> `gamemoded -t`

Usage
---

On steam (in the launch options):

```steam
gamemoderun %command%
```

A more involved configuration. The former is recommended, this might be overkill.:

```steam
 gamemoderun %command% -high -vulkan -sw -w 2560 -h 1440 -freq 144 -nojoy -console
```


Configuration
---

The configuration is in `/etc/gamemode.ini`

```ini
[general]
renice=10
```



Minimum working config examples:
---