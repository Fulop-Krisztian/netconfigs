---
title: Systemd overview
tags:
  - linux
  - overview
  - basic
  - todo
---
Basics

Related
---
[Systemd service](Systemd%20service.md)

[Systemd mount](Systemd%20mount.md)

Sources
----
[RHEL wiki](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_systemd_unit_files_to_customize_and_optimize_your_system/assembly_working-with-systemd-unit-files_working-with-systemd#assembly_working-with-systemd-unit-files_working-with-systemd)
Unit files
---

systemctl
---
You will use this command a lot of you use `systemd`. The main things you can do with it are here. This is mostly regarding units, especially services. But you can do other things, shutting down the system with `systemctl poweroff`

> [!IMPORTANT]
> Most commands here require root permissions.
> 
> Some units run in the scope of the user (like [[pipewire]] on most desktop distros). You can specify these like so:  `systemctl --user start pipewire`

#### status

Without a doubt the most useful `systemctl` command. You can use it to check whether a unit is running and enabled, how long a unit has run for, how much CPU time it has used so far, its last few lines of log, and a lot of other useful info.

```bash
systemctl status <unit_name>
```

> [!TIP]
> If you can't see logs (or other data you might expect), try running it with root permissions (`sudo`)

#### start

 You would use this when installing something that doesn't get started automatically, or starting something that has stopped for some reason.

```bash
systemctl start <unit_name>
```

> [!IMPORTANT]  
> You still have to [enable](#enable) the service if you want it to start automatically on boot
#### stop

The opposite of start. This stops the unit.

> [!IMPORTANT]  
> You have to [[#disable]] the service if you don't want it to restart on reboot


```bash
systemctl stop <unit_name>
```

#### enable

To make `systemd` automatically start a service as part of booting up, you have to enable it. This does not [start](#start) the service until you reboot

```bash
systemctl enable <unit_name>
```

#### disable

If you want to prevent something from starting on boot, you can disable it. This does not [stop](#stop) the service until you reboot

```bash
systemctl disable <unit_name>
```

#### edit

This is a bit more of an advanced command. With this you can edit a unit's file, for example for a [service](Systemd%20service.md#Configuration).

```bash
sytemctl edit <unit_name>
```

