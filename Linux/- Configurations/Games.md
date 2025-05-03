# Configurations for gaming on linux

tags: #linux #desktop #fix #todo 


Terminology, general knowledge
---
- Proton is used for Windows games. It's very prevalent so you should get familiar with it.
- Assumption here is that your distribution is already somewhat configured for gaming, meaning you can launch a Windows program at least, and have a desktop environment. Steam and a third party launcher for cracked games will take care of the rest.


Prerequisites
---
- Wine and Proton, and a launcher to use them to make your life easier (I use [Heroic](https://heroicgameslauncher.com/), but [Lutris](https://lutris.net) is a very popular alternative, along with [Bottles](https://usebottles.com/) (Which is more focused on running Windows apps in general))

Sources
---
[Linux cracked games wiki, a lot of useful info here](https://www.reddit.com/r/LinuxCrackSupport/wiki/index/)  


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


