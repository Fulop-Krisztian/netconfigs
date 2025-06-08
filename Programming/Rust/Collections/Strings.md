---
title: Strings
tags:
  - programming
  - rust
  - basic
---
Terminology, general knowledge
---
- Strings are a complicated data type in all languages
- Strings are built on top of Vectors, and thus a lot of operations that work with vectors work with strings as well
- You **CANNOT** index a string. This is because strings use UTF-8 characters, and UTF-8 characters are variable length. If you were to index a string, you might index into the middle of a multi-byte character. There are other methods of getting the characters of a string however.

Prerequisites
---


Sources
---


Configuration
---


Config examples:
---