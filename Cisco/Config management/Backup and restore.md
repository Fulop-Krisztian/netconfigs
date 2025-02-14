# Backup and restore cisco configurations quickly

Terminology, general knowledge
---
- You should do backups.

Prerequisites
---
- A configuration that already exists

Backup methods
---

#### Local backup
This one is a quick method, without requiring any external devices.

To back up your configuration and erase the current one (very useful when working on shared lab devices)

> [!IMPORTANT]
> The newlines between the commands have significance here. They tell the commands to proceed.

##### Backup

```
en

copy running-config flash:/config-backup

erase startup-config

reload

no

```
##### Restore

```
no

en

copy flash:/config-backup startup-config

copy flash:/config-backup running-config


```


