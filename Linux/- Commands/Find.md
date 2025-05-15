---
title: Find
tags:
  - linux
  - basic
---
Terminology, general knowledge
---
- YOU HAVE TO USE A SINGLE DASH. I don't know why, but you have to use a single dash. This goes against the convention. Why would they do this?

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