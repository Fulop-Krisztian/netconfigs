# Fixing bad NTFS partitions in Windows
created: 2025-02-27 19:33
tags: #windows #desktop #fix
Terminology, general knowledge
---


Prerequisites
---


Sources
---


Configuration
---
You will most likely run this command:

```powershell
chkdsk <drive> /f
```

Minimum working config examples:
---
- `chkdsk C:` : Check the C: drive for errors.
- `chkdsk C: /f` : Check and fix errors on the C: drive.
- `chkdsk D: /r` : Check the D: drive for bad sectors and recover readable information.
- `chkdsk C: /f /r /x` : Check the system drive (C:) for errors, fix them, locate bad sectors, and recover readable information. This command will require a restart.
