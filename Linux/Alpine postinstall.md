# Alpine postinstall configurations
These are configurations I use after installing Alpine Linux (tested on a sys disk install)

Useful links
---

[Alpine linux wiki](https://wiki.alpinelinux.org/wiki/Installation#Post-Installation)

[Alpine repos online search](https://pkgs.alpinelinux.org/packages)

Configurations from setup-alpine
---
```bash
apk update
apk upgrade
apk add nano
apk add busybox-extras
```

```bash
nano /etc/apk/repositories
# Remove the comment from in front of the community repo
```

```bash 
apk add npm
apk add git
```

Change the `/etc/issue` and `/etc/motd` files to your liking

Change in `/etc/rc.conf`:  `rc_parallel="YES"`
> [!WARNING]  
> This could mess some things up.


If you want a desktop:
```bash
setup-desktop
# To disable autostart
rc-update del lightdm default
# To start after autostart has been disabled:
rc-update add lightdm default
```


> [!TIP]
> Important note for updating:
apk will avoid overwriting files you may have changed. These will usually be in the /etc directory. Whenever apk wants to install a file, but realizes a potentially edited one is already present, it will write its file to that filename with .apk-new appended. You may handle these by hand, but a utility called update-conf exists. Simply invoking it normally with present you with the difference between the two files, and offer various choices for dealing with the conflicts.

