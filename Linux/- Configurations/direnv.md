---
title: direnv
tags:
  - linux
  - desktop
  - automation
  - etc
---
Terminology, general knowledge
---
- direnv is an environment variable manager for your shell
- It supports [[bash]], [[zsh]], and [[fish]].

Prerequisites
---
- You've installed direnv (`yay -S direnv`)

Sources
---
[Arch manuals](https://man.archlinux.org/man/direnv.1.en)

Shell configuration for usage
---
#### Fish

Add the following line at the end of the **$XDG_CONFIG_HOME/fish/config.fish** (usually /home/user/.config/fish/config.fish) file:

```config.fish
direnv hook fish | source
```


#### Project directory configuration

In your project directory root give this command:

```bash
`echo 'layout python3' > .envrc`
direnv allow
```

You're done. If you enter this directory, you should automatically enter the venv. If you leave the directory it should automatically unload it.
Config examples:
---