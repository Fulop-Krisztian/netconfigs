> [!info] Mine of Information - Beginner's Guide to Installing from Source  
> Categories: Linux  
> [https://moi.vonos.net/linux/beginners-installing-from-source/](https://moi.vonos.net/linux/beginners-installing-from-source/)  

> [!info] Building and Installing Software Packages for Linux: Introduction  
> Many software packages for the various flavors of UNIX and Linux come as  
> [https://tldp.org/HOWTO/Software-Building-HOWTO-1.html](https://tldp.org/HOWTO/Software-Building-HOWTO-1.html)  

# The short version:

```Bash
# unpack and read documentation
tar xf filename
cd {directory created by above step}
less README
less INSTALL

# generate customised makefile (optional)
./configure {some options ...}

# compile everything in the local directory
make

# update global directories
sudo make install
```

# The long version:

### 1. Why are packages built?

Many software packages for the various flavors of UNIX and Linux come as compressed archives of source files. The same package may be "built" to run on different target machines, and this saves the author of the software from having to produce multiple versions.

A single distribution of a software package may thus end up running, in various incarnations, on an Intel box, a DEC Alpha, a RISC workstation, or even a mainframe.  
  

Unfortunately, this puts the responsibility of actually "building" and installing the software on the end user.

  

## 1. Unpacking the Files

`tar -xvf(z)` `_filename_`

Sometimes the archived file must be untarred and installed from the user's home directory, or perhaps in a certain other directory, such as `/`, `/usr/src`, or `/opt`, as specified in the package's config info

You may preview this process by a `tar tzvf` _`filename`_, which lists the files in the archive without actually unpacking them.

### 1.1 Checksum:

To compute the MD5 sum of a single file: `md5sum` _`file-to-check`_

Then check against the other MD5 hash manually
  

If the software provider provides an md5sums file which has a list of (filename, checksum) pairs, then you can run:

`md5sum -c` _`md5sums-file`_

This checks automatically and throws an error if something isn’t right

  

Some software providers _sign_ archive files instead of (or as well as) providing an md5 checksum. In this case you should:

- download the provider’s _public key_ from their website (using https where possible)
- download the “signature file” for the archive-file; this  
    will be a small file which has the same base name as the downloaded  
    file, with suffix “.sig” or “.asc”  
    
- perform the following steps:

`# needed only once for each key, ie each "publisher" gpg --import {public-key} gpg --verify {signature-file-name}`

  

### 1.2 Extra unpacking options:

```Bash
   # Modern GNU tar options. This works for files compressed
   # with gzip and bzip too
   tar --extract --file filename

   # Same as above
   tar -xf filename

   # Same as above. Leading "-" is optional
   tar xf filename

   # explicitly decompress gzip2-compressed file then
   # pass uncompressed result directly into tar
   gzip -cd filename.tgz | tar xf -

   # same as above, but for bzip2-compressed files
   bunzip2 -cd filename.tar.bz2 | tar xf -
```

## 2. Using Make

**READ THE README THAT COMES WITH THE ARCHIVE**

  
Make makes building the binaries easy as I understand. It pretty much does everything that is described in the `Makefile`

### 2.1 Simple software (if imake is not present):

The `Makefile` is the key to the build process. In its simplest form, a Makefile is a script for compiling or building the "binaries"

  

Invoking _make_ usually involves just typing **`make`**

Installing the files in their proper directories: `make install`

Removing stale object files: `make clean`

Running `make -n` permits previewing the build process, as it prints out all the commands that would be triggered by a make, without actually executing them.

  

### 2.2 Complex software (If there’s an imake file in the de-archived folder):

`Imake` and `xmkmf` accomplish this task.

  

An `Imakefile` is, to quote the man page, a "template"  
Makefile. The  
`imake` utility constructs a Makefile appropriate for your  
system from the Imakefile. In almost all cases, however, you would run  
  
`**xmkmf**`

  

You would normally invoke  
  
`**xmkmf**` with the **-a** argument, to automatically do a  
_make Makefiles, make includes,_ and _make depend_

  

- Read the README file and other applicable docs.
- Run `**xmkmf -a**`, or the `INSTALL` or `configure` script.
- Check the `Makefile`.
- If necessary, run `**make clean**`, `**make Makefiles**`,  
      
    `**make includes**`, and `**make depend**`.
- Run `**make**`.
- Check file permissions.
- If necessary, run **make install**.

  

## 3. Prepackaged Binaries

> [!info] Building and Installing Software Packages for Linux: Prepackaged Binaries  
>  
> [https://tldp.org/HOWTO/Software-Building-HOWTO-4.html](https://tldp.org/HOWTO/Software-Building-HOWTO-4.html)  

In their most simple form, the commands `rpm -i` _`packagename.rpm`_ and `dpkg --install` _`packagename.deb`_ automatically unpack and install the software

  

The [martian](http://www.people.cornell.edu/pages/rc42/program/martian.html) and [alien](http://kitenet.net/programs/alien/) programs allow conversion between the _rpm_, _deb_, Stampede _slp_, and _tar.gz_ package formats. This makes these packages accessible to all Linux distributions.

  

Troubleshooting:

> [!info] Building and Installing Software Packages for Linux: Troubleshooting  
>  
> [https://tldp.org/HOWTO/Software-Building-HOWTO-7.html](https://tldp.org/HOWTO/Software-Building-HOWTO-7.html)  

## 4. Patching

### **Sed Command:**

Use the `sed` tool to apply regular expressions to each line in a text file and substitute matching text with another string. Although limited, `sed` is user-friendly and widely accessible.

### Awk Command:

`Awk` operates similarly to `sed` but allows for more intricate text file transformations, capable of performing complex modifications.

### Patchfile:

A `patchfile` is generated by the "diff" tool, comparing two file versions and detailing the differences. Utilize the `patch` tool to apply the output of "`diff`" to convert one file version to another. Patchfiles, or diff outputs, are human-readable, offering transparency regarding the impending changes.

## 5. Post install

When compiling and linking to generate the desired "executables," they often contain substantial amounts of data beneficial for debugging programs, but unnecessary for regular end users. Removing this information from the executable files is possible by executing the command `strip {filename}`. This action results in smaller programs that not only conserve disk space but also load slightly faster.

  

![[../../../- Attachments/Make pipeline.png]]

Flow diagram of autoconf and automake