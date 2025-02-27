
> [!info] Filesystem Hierarchy Standard  
> This standard consists of a set of requirements and guidelines for file and directory placement under UNIX-like operating systems.  
> [https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html)  

## directories in / (root)

### Required

The following directories, or symbolic links to directories, are  
required in  
`/`.

|Directory|Description|Notes|
|---|---|---|
|`bin`|Essential command binaries|NO DIRECTORIES, there are [required binaries](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s04.html) (like cat or dd)|
|`boot`|Static files of the boot loader|kernel is here or in `/`|
|`dev`|Device files|research further into MAKEDEV|
|`etc`|Host-specific system configuration  <br>(short for Editable Text Config)|[lots of standards](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s07.html), sub-directories are only recommended|
|`lib`|Essential shared libraries and kernel modules|libraries that only `/usr` programs use can’t be in here (they must be in `/usr/lib`)|
|`media`|Mount point for removable media|lots of distros use this for automounting as well (any mounting for that matter)|
|`mnt`|Mount point for mounting a filesystem temporarily|intended as a temporary mount-point (like when installing arch)|
|`opt`*|Add-on application software packages|Apparently this is made pretty much redundant by package managers|
|`run`|Data relevant to running processes|**Cleared** at the BEGINNING of boot|
|`sbin`|Essential system binaries|Originally, `/sbin` binaries were kept in`/etc`.  <br>Only  <br>`shutdown` is required by default|
|`srv`|Data for services provided by this system|server things, eg: Ubuntu Server uses `/srv/www/html` as default apache folder|
|`tmp`|Temporary files|Programs must assume it’s cleared after they’re closed. Recommended to be cleared on boot|
|`usr`|Secondary hierarchy  <br>(short for Universal Shared Resources)|rabbit hole. NOTHING host specific, meant to be read only|
|`var`|Variable data|[rabbit hole v2](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch05.html), things created during normal system operation|

*[Linux](https://tldp.org/HOWTO/Software-Building-HOWTO-3.html): Packages originally targeted for commercial versions of UNIX may attempt to install in the `/opt` or other unfamiliar directory. This will, of course, result in an installation error if the intended installation directory does not exist. The simplest way to deal with this is to create, as root, an `/opt` directory, let the package install there, then add that directory to the `PATH` environmental variable. Alternatively, you may create symbolic links to the `/usr/local/bin` directory.

  

Each directory listed above is specified in detail in separate  
subsections below.  
`/usr` and  
  
`/var` each has a complete section in this  
document due to the complexity of those directories.  

### Optional

The following directories, or symbolic links to directories,  
must be in  
`/`, if the corresponding subsystem is  
installed:  

|Directory|Description|Notes|
|---|---|---|
|`home`|User home directories (optional)|User specific configs are stored here, they start with a `.`|
|`lib``_<qual>_`|Alternate format essential shared libraries (optional)||
|`root`|Home directory for the root user (optional)|Oxymoronic in my opinion. (don’t use root ever, but let root have a home folder). Don’t use root when you can get away with not using it|

Each directory listed above is specified in detail in separate  
subsections below.  

  

## directories in /usr

> [!info] Chapter 4. The /usr Hierarchy  
> Table of Contents  
> [https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04.html](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04.html)  

  

`/usr` is the second major section of the filesystem. It is shareable, read-only data. That means that should be shareable between various FHS-compliant hosts and must not be written to. Any information that is host-specific or varies with time is stored elsewhere.

Large software packages must not use a direct subdirectory under the `/usr` hierarchy.

  

The following directories, or symbolic links to directories, are  
required in  
`/usr`.

|Directory|Description|Notes|
|---|---|---|
|`bin`|Most user commands|Primary directory of executable commands. No directories|
|`lib`|Libraries|Libraries for programming and packages|
|`local`|Local hierarchy (empty after main installation)|rabbit hole v3.|
|`sbin`|Non-vital system binaries|no directories, used for recovery|
|`share`|Architecture-independent data|[complex](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04s11.html), read only|
|`libexec`|Binaries run by other programs|(Optional)|

## directories in /usr/local

> [!info] Chapter 4. The /usr Hierarchy  
> Table of Contents  
> [https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04.html](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04.html)  

  

`/usr` is the second major section of the filesystem. is shareable, read-only data. That means that should be shareable between various FHS-compliant hosts and must not be written to. Any information that is host-specific or varies with time is stored elsewhere.

Large software packages must not use a direct subdirectory under the `/usr` hierarchy.

  

The following directories, or symbolic links to directories, are  
required in  
`/usr`.

|   |   |   |
|---|---|---|
|Directory|Description|Notes|
|`bin`|Most user commands|Primary directory of executable commands. No directories|
|`lib`|Libraries|Libraries for programming and packages|
|`local`|Local hierarchy (empty after main installation)||
|`sbin`|Non-vital system binaries||
|`share`|Architecture-independent data||
|`libexec`|Binaries run by other programs|(Optional)|

  

The `/usr/local` hierarchy is for use by the system administrator when installing software locally. It needs to be safe from being overwritten when the system software is updated. It may be used for programs and data that are shareable amongst a group of hosts, but not found in `/usr`.

  

The following directories, or symbolic links to directories,  
must be in  
`/usr/local`. NO OTHER DIRECTORIES ALLOWED

|Directory|Description|Notes|
|---|---|---|
|`bin`|Local binaries|this|
|`etc`|Host-specific system configuration for local binaries|is|
|`games`|Local game binaries|getting|
|`include`|Local C header files|ridiculous|
|`lib`|Local libraries||
|`man`|Local online manuals||
|`sbin`|Local system binaries||
|`share`|Local architecture-independent hierarchy||
|`src`|Local source code||

## directories in /var

> [!info] Chapter 5. The /var Hierarchy  
> Table of Contents  
> [https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch05.html](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch05.html)  

  

`/var` contains variable data files. This includes spool directories and files, administrative and logging data, and transient and temporary files.

|Directory|Description|Notes|
|---|---|---|
|`cache`|Application cache data||
|`lib`|Variable state information||
|`local`|Variable data for /usr/local||
|`lock`|Lock files|locks on devices, like serial or tty|
|`log`|Log files and directories|`messages` for systemd|
|`opt`|Variable data for /opt||
|`run`|Data relevant to running processes||
|`spool`|Application spool data|Data which is awaiting some kind of later processing, also printers|
|`tmp`|Temporary files preserved between system reboots||