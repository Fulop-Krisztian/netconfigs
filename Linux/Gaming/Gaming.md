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

#### Change keyboard layout/language/locale inside game
The keyboard layout of games run inside wine/proton are separate from your actual desktop environment layout (on Wayland at least).

[According to the documentation](https://gitlab.winehq.org/wine/wine/-/wikis/Translating#how-do-i-test-my-translation) "Wine uses the operating system's locale to decide what language *(also meaning keyboard layout)* to use, but this can be overridden by changing the `LANG` environment variable". You can also set `LC_ALL` instead of `LANG` to override the full locale, not just the language (the locale includes number formatting, currency, units, etc...).

To get a list of locales that are available on your system:
```bash
locale -a
```

You should see something similar to these:
```
C  
C.utf8  
en_US.utf8  
hu_HU.utf8  
POSIX
```

> If you can't see the locale that you want to change your layout to, you need to install it. You do this through your package manager.

Now you just need to run wine with the environment variables. You can configure this in your game launcher (like Heroic), or you can just run a program from terminal like this:

```bash
LANG="en_US.utf8"
# or
LC_ALL="en_US.utf8"
wine <program>
```
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


