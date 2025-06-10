---
title: Configurations for gaming on linux
tags:
  - linux
  - desktop
  - fix
  - todo
  - overview
---
Terminology, general knowledge
---
- Proton is used for Windows games. It's very prevalent so you should get familiar with it.
- Assumption here is that your distribution is already somewhat configured for gaming, meaning you can launch a Windows program at least, and have a desktop environment. Steam and a third party launcher for cracked games will take care of the rest.


Prerequisites
---
- Wine and Proton, and a launcher to use them to make your life easier. I use [Heroic Games Launcher](https://heroicgameslauncher.com/) (available on Windows too), but [Lutris](https://lutris.net) is a very popular alternative. Another popular choice is [Bottles](https://usebottles.com/) (Which is more focused on running Windows apps in general)

Sources
---
The most important: [ProtonDB](https://www.protondb.com/). Here you can check if a game has any issues running on Linux. You can also check SteamDeck support here.

[Linux cracked games wiki, a lot of useful info here](https://www.reddit.com/r/LinuxCrackSupport/wiki/index/)  


Gaming related things
---

[Gamemode for better game stability and performance](GameMode.md)

[Migrating all of your Windows game saves to Linux the simple way](Windows%20saves.md)


Common pitfalls:
---

> [!WARNING]  
> If you are migrating from Windows, and some of the games you install don't seem to work, check if you are installing on an NTFS partition. NTFS can also cause issues both when only the game files are on in, or only when the Wine prefix folder is on it.
> 
> Use another, simple filesystem, like [EXT4](https://en.wikipedia.org/wiki/Ext4). You can also use more advanced filesystems, supposing you have the time and inclination to learn about them: [BTRFS](../Filesystems/BTRFS.md), [ZFS](../Filesystems/ZFS.md)



Environment variables:
---
These environment variables can optimize your gaming experience, or may be a requirement to launch the game at all.
### Fixes

#### Online-fix.me fix

Online-fix.me cracks use custom dlls, which wine ignores by default. To override this ignore behavior, use the following environment variable:

```bash
WINEDLLOVERRIDES="OnlineFix64=n;SteamOverlay64=n;winmm=n,b;dnet=n;steam\_api64=n"
```

This may not work in all cases. For further fix possibilities read through:
https://github.com/BadKiko/steam-online-fix-launcher/blob/main/README.md


### Convenience
#### OpenGL no minimization on focus loss

```bash
SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
```


