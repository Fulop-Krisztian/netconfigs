---
title: Install
tags:
---
Arch:

```sh
sudo pacman -S neovim
```


From source (do this on Debian because the packaged version is usually out of date):

```sh
git clone --depth=1 https://github.com/neovim/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```


