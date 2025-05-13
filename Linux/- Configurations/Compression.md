---
title: Compression
tags:
  - linux
  - desktop
  - etc
  - basic
---
Terminology, general knowledge
---
- Compression takes a blob of data, and makes it a smaller blob of data
- Data aggregation (Like putting a directory into a blob, so that it may be compressed), is not necessarily the compression program's job. We usually use tar for that
- In general:
	- Use [ZSTD](Compression.md#ZSTD) for fast compression and good compression
	- Use [XZ](Compression.md#XZ) for archival compression where you want something to be as small as possible. It's not that much better than ZSTD (around ~5% at most on high settings [or even less](https://en.wikipedia.org/wiki/Zstd#Usage)), while being much, much slower for decompression in most cases. For compression it varies.
	- Use [[gzip]] for compatibility

Prerequisites
---
- You have the mentioned compression programs installed. They should come by default on most systems.
- You have good enough hardware, if you want to run the highest settings.

Sources
---
https://wiki.archlinux.org/title/Archiving_and_compression



Configuration
---

### ZSTD

ZSTD offers a compression ratio among the best ones, and a speed that is unrivaled for the compression it achieves. Its decompression is even faster. A good archival command for it might look like this:

#### Recommended command:
```bash
zstd -c -T0 --ultra --long -20 <input> > <output>
```

- `T0`: Use all available threasd
- `--ultra`: Allows you to use compression settings above 19, to the limit of 22
- `--long`: Use a longer context window, [it has addtional options too](https://news.ycombinator.com/item?id=16228217). Uses more memory.
- `-20`: Use level 20 for compression. Levels go from -7 to 22, don't ask why. -7 is fastest, 22 is best compression.

> [!NOTE]  
> You can also use it (along with other compression algorithms, but this is the most suitable for the job, to the point that even HTTP uses it) to compress network traffic on the fly, before transmission. [Compression over SSH](../-%20Commands/Command%20compendium.md#Compression) when using `dd` over SSH is one method of using this.

Depending on the network, the total throughput could end up higher in the end than if you were to just send it without compression, even with the compression overhead for the server.


It is so fast in fact, that it can be used as transparent compression for filesystems. You would use it with more normal settings though, around level 4 (for example [BTRFS](../Filesystems/BTRFS.md))

XZ
---
XZ is best for archival storage, because it is slow to both compress and decompress. It is, however, better at multi-threading than ZSTD.

A command for it might look like this
```bash
xz
```


Examples:
---

#### ZSTD:
##### High compression with ZSTD:

Directory:
```bash
tar -cf - <path-to-folder> | zstd -c -T0 --long -19 - > <arc  
hive_name>.tar.zst
```

Single file:
```bash
zstd -c -T0 --long -19 <filename> > <filename>.zst
```
##### Extreme compression with ZSTD:

Directory:
```bash
tar -cf - <path-to-folder> | zstd --long=31 --ultra -22 -T0 - > <arc  
hive_name>.tar.zst
```
Single file:
```bash
zstd -c -T0 --long=31 --ultra -19 <filename> > <filename>.zst
```



#### High compatibility 
For example with for sharing with [Windows](../../Windows/Windows.md), (Though Windows usually has no issues with even XZ or ZSTD decompression). the ZIP format is very universal

```bash
zip <output_file_name>.zip <file_name1> <file_name2>
```