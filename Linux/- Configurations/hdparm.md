---
title: Configuring HDD standby with hdparm
tags:
  - linux
  - etc
  - desktop
  - firmware
---
Configuration
---

The hdparm configuration file is `/etc/hdparm.conf`. It's very verbose, and has basic example. One example might be:

```hdparm.conf
# This sets the disk up to spin down after 10 minutes of idling
/dev/sda {
    apm = 128
    spindown_time = 120
}
```

You can also use `/dev/disk/by-id/<disk_id>` to specify the disk

> [!TIP]
> You can list your disks with the following command. You can choose either ID from the output.

```bash
lsblk |awk 'NR==1{print $0" DEVICE-ID(S)"}NR>1{dev=$1;printf $0" ";system("find /dev/disk/by-id -lname \"*"dev"\" -printf \" %p\"");print "";}'|grep -v -E 'part|lvm'
```
Terminal usage
---
> [!NOTE]  
> These settings don't persist across reboots. For that use the [configuration file](hdparm.md#Configuration)
#### Manually spin down disk immediately 

```bash
sudo hdparm -y /dev/sdX
```

You can also force it:

```bash
sudo hdparm -Y /dev/sdX
```

#### Set Automatic Standby Timeout

```bash
sudo hdparm -S <value> /dev/sdX
```

- `<value>` is a multiple of 5 seconds:
  - `1` = 5 seconds
  - `12` = 1 minute
  - `241` to `251` = 30 min to 5.5 hours (in 30 min steps)
  - `0` = never spin down (disable standby)

**Examples:**
```bash
# Set drive to spin down after 10 minutes of inactivity
sudo hdparm -S 120 /dev/sda

# Disable standby timeout
sudo hdparm -S 0 /dev/sdb
```

#### View Current Settings

```bash
sudo hdparm -I /dev/sdX
```
