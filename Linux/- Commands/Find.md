---
title: Find
tags:
  - linux
  - basic
---
Terminology, general knowledge
---


Prerequisites
---


Sources
---


Configuration
---


Minimum working config examples:
---

Find all files in the current directory which are newer than the given date, and copy them over into a new directory, while preserving the directory structure

```bash
find . -type f -newermt 2024-05-11 -exec cp --parents {} ../<directory> \;
```