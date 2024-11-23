# Alpine postinstall configurations
These are configurations I use after installing Alpine Linux (tested on a sys disk install)

Useful links
---

[Alpine linux wiki](https://wiki.alpinelinux.org/wiki/Installation#Post-Installation)

[Alpine repos online search](https://pkgs.alpinelinux.org/packages)

Configurations to run after `setup-alpine`
---

First, enable community repos
```bash
nano /etc/apk/repositories
# Remove the comment from in front of the community repo
```


basic packages
```bash
apk update
apk upgrade
apk add nano
apk add busybox-extras
# glibc compatibility
apk add gcompat
# loadkeys
apk add kbd
```

> [!TIP]
> Important note for updating:
apk will avoid overwriting files you may have changeflicts.
d. These will usually be in the /etc directory. Whenever apk wants to install a file, but realizes a potentially edited one is already present, it will write its file to that filename with .apk-new appended. You may handle these by hand, but a utility called update-conf exists. Simply invoking it normally with present you with the difference between the two files, and offer various choices for dealing with the con


```bash 
# You will probably use this sooner or later, might as well add it now.
apk add git
# Blasphemy (It really is useful though)
apk add mc
# Apache2 for testing. You should enable this afterwards with rc-service add apache2 default/async
apk add apache2
```

If you want a desktop:
```bash
setup-desktop

# To disable autostart
rc-update del lightdm default

# To reenable autostart:
rc-update add lightdm default
```

Optimizing boot time
---

The biggest boot time optimization is changing the IP to static. If you can you should. (`/etc/network/interfaces`)

> [!WARNING]  
> The following config could mess some things up. Worked for me but could prevent the system from starting in some cases

Change in `/etc/rc.conf`:  `rc_parallel="YES"`

> [!NOTE]
> Tiny boot time optimization. Setting it to 0 actually pauses the boot process until manual input, so set it to 1

Change in `/boot/extlinux.conf`: `TIMEOUT 1`

> [!IMPORTANT]  
> Alpine has a utility called `update-exlinux` (config file: `/etc/update-extlinux.conf`), where the lowest timeout is 1 second (TIMEOUT 10). 
> It runs automatically sometimes (for example when you update `syslinux`), but if you notice that the boot time is slower than usual (by 0.9 seconds), check if your boot extlinux configuration hasn't been overwritten.

### Starting services in an async way:

[Alpine wiki on slow services delaying boot](https://wiki.alpinelinux.org/wiki/OpenRC#Preventing_slow_services_from_delaying_boot)

```bash
mkdir /etc/runlevels/async
rc-update add -s default async
# This is the NTP service, often quite slow
rc-update del chronyd
rc-update add chronyd async
# SSHD
rc-update del sshd
rc-update add sshd async
# Apache2
rc-update del apache2
rc-update add apache2 async
```

after this, go to `/etc/inittab` and add `::once:/sbin/openrc async --quiet`
> [!TIP]
> Without quiet, it would mess up the login prompt, so it's better to keep it that way.

Welcome messages
---
Change the `/etc/issue` and `/etc/motd` files to your liking

### Automatically display IP in issue:

You must place this in `/etc/network/if-up.d/update-issue-ip` (filename can be whatever you want)

```
#!/bin/sh

# Configure the interface if you must. This works on virtual machines
IPV4=$(ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d:)

# Don't know how exactly this works
cat <<'EOF' > /etc/issue
.........      .......
........        ......  LL     IIIIII NN   NN UU  UU XX  XX
........        ......  LL       II   NNN  NN UU  UU  XXXX
........         .....  LL       II   NNNN NN UU  UU   XX
........         .....  LL       II   NN NNNN UU  UU  XXXX
........ `----'  .....  LLLLLL IIIIII NN   NN  UUUU  XX  XX
........ ......   ....
....... ........    ..  Kernel \r on an \m (\l)
....... .........    .
....... .........    .
...... ..........
.....  ..........
.....   ........
...     ........
.       ........
.        ......

Login: root
Password: a

EOF


if [ ! -z "$IPV4" ]; then
    echo "IP Address: $IPV4 (hostname: \n)" >> /etc/issue
fi
```

> [!IMPORTANT]  
> This way issue gets updated if any interface goes up. It will not update automatically if no interface went up, which means that if you don't get an IP for some reason, you will see the last IP that the interface had.

