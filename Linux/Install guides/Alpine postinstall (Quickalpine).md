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

# These are optinal but add quite a bit of functionality
apk add lsblk htop net-tools traceroute tree file zip util-linux coreutils netcat-openbsd 
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
Don't forget to make the script executable

```bash
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


Configuration script:
---

```bash
#!/bin/sh

# Step 1: Enable community repositories
echo "Enabling community repositories..."
sed -i '/community/s/^#//' /etc/apk/repositories

# Step 2: Update and install basic packages
echo "Updating APK repositories and upgrading packages..."
apk update && apk upgrade

echo "Installing basic packages... (~40MB)"
apk add nano busybox-extras gcompat kbd git mc apache2 lsblk htop net-tools traceroute tree file zip util-linux coreutils netcat-openbsd

# Step 3: Desktop setup (optional)
echo "Do you want to setup a desktop environment? (y/N)"
read DESKTOP_SETUP
if [ "$DESKTOP_SETUP" = "y" ]; then
    echo "Setting up desktop environment..."
    setup-desktop
    echo "Disabling LightDM autostart..."
    rc-update del lightdm default
    echo "To reenable autostart, run: rc-update add lightdm default"
else
    echo "Skipping desktop setup."
fi

# Step 4: Optimizing boot time
echo "Optimizing boot time..."

# Warning about potential issues with static IP
echo "IMPORTANT: Changing to a static IP can greatly improve boot times. Please configure /etc/network/interfaces manually if needed."

# Enable parallel booting
echo "Enabling parallel booting in /etc/rc.conf..."
sed -i 's/^#rc_parallel="NO"/rc_parallel="YES"/' /etc/rc.conf

# Set boot timeout to 1 second
echo "Setting boot timeout to 1 second in /boot/extlinux.conf..."
sed -i 's/TIMEOUT [0-9]\+/TIMEOUT 1/' /boot/extlinux.conf

# Warning about update-exlinux overwriting the boot timeout
echo "Remember: update-extlinux may reset the timeout. If your boot time becomes slower, check /boot/extlinux.conf."

# Step 5: Configuring services for asynchronous startup
echo "Configuring services for asynchronous startup..."

# Create async runlevel directory if it doesn't exist
mkdir -p /etc/runlevels/async

# Add async runlevel to default runlevel
rc-update add -s default async

# Reconfigure services to start asynchronously
echo "Moving slow services to async..."
rc-update del chronyd
rc-update add chronyd async
rc-update del sshd
rc-update add sshd async
rc-update del apache2
rc-update add apache2 async

# Add openrc async to inittab
echo "Adding async OpenRC command to /etc/inittab..."
echo '::once:/sbin/openrc async --quiet' >> /etc/inittab

# Step 6: Customize welcome messages and update IP dynamically
echo "Setting up automatic /etc/issue update with IP address..."

# Configure MOTD
cat << 'EOF' > /etc/motd

 ██████╗ ██╗   ██╗██╗ ██████╗██╗  ██╗ █████╗ ██╗     ██████╗ ██╗███╗   ██╗███████╗
██╔═══██╗██║   ██║██║██╔════╝██║ ██╔╝██╔══██╗██║     ██╔══██╗██║████╗  ██║██╔════╝
██║   ██║██║   ██║██║██║     █████╔╝ ███████║██║     ██████╔╝██║██╔██╗ ██║█████╗  
██║▄▄ ██║██║   ██║██║██║     ██╔═██╗ ██╔══██║██║     ██╔═══╝ ██║██║╚██╗██║██╔══╝  
╚██████╔╝╚██████╔╝██║╚██████╗██║  ██╗██║  ██║███████╗██║     ██║██║ ╚████║███████╗
 ╚══▀▀═╝  ╚═════╝ ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝╚══════╝

https://wiki.alpinelinux.org

Alpine uses *openrc* instead of systemd, this means that instead of systemctl, you must use *rc-service <service> <action>* 
Example: rc-service sshd status

EOF

# Full content for /etc/network/if-up.d/update-issue-ip
cat << 'EOF' > /etc/network/if-up.d/update-issue-ip
#!/bin/sh

# Configure the interface if you must. This works on virtual machines
IPV4=$(ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d:)

# Full content of /etc/issue file
cat <<'EOT' > /etc/issue
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

EOT

# If IP address is available, append it to /etc/issue
if [ ! -z "$IPV4" ]; then
    echo "IP Address: $IPV4 (hostname: \n)" >> /etc/issue
fi
EOF

# Make the script executable
chmod +x /etc/network/if-up.d/update-issue-ip

echo "Configuration complete. Please review any manual steps such as static IP setup."
```