---
title: rsync
tags:
  - linux
  - basic
---
Terminology, general knowledge
---
- Rsync is a really powerful tool for moving, copying, updating, syncing, and backing up files and directories
- It uses BSD trailing slash conventions. In short this means that the `/etc` path means the `etc` directory, while the `/etc/` path would mean the files in the directory.
- You can use it for local as well as remote transfers
- **It has partial transfers.** Suppose you have an unstable connection and sometimes the network drops out (or you have an external drive with a loose cable locally). If the connection and the transfer breaks, progress is not lost. If you reconnect and give the same command again, the transfer will pick up where it left off.
- You can use it for:
	- Backups (Full and delta)
	- Copying
	- Syncing 
	- Updating (somewhat like git, except it only looks at the dates of files)
- It's a bit slower than basic copying (with `cp`)

Prerequisites
---
- A basic understanding of SSH
- Install rsync

Sources
---
[rsync man page](https://linux.die.net/man/1/rsync)

[Arch wiki](https://wiki.archlinux.org/title/Rsync) (There is a huge section for the different way you can use this utility to do backups)

[Useful Youtube video](https://www.youtube.com/watch?v=eifQI5uD6VQ)
Usage
---
#### Basic syntax


```bash
rsync <local_file> <user>@<remote_host>:<remote_file>
```

> [!TIP]
> The user and the remote file is optional. If you don't give them, it will assume the same user as the sending one, and assume the file should be of the same name as the source, in home.

For example:

```bash
rsync file remoteserver:
```

#### Almost-always use flags

- `-r`: Recursive (Directory copy)
- `-P`: Is short for `--partial` and `--progress`
- `-a`: Archive mode. Use this for system files and files where you want to preserve metadata
- `-v`: Verbose
- `-h`: Human readable values (like MB, GB)

```
rsync -rPavh
```
#### Behavior-changing flags

- `--delete-after`: Makes rsync delete files on the remote. (basically syncing the two directories).
- `--update`: Skip files that are newer on the receiver. 

Threre are hundreds of other flags


Config examples:
---