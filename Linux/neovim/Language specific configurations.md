---
title: Language specific configurations
tags:
---
These should go in `~/.config/nvim/after/ftplugin/<type>.lua`

For example, in `lua.lua` for changing how Lua files behave:

```lua
local set = vim.opt_local

set.shiftwidth = 4
set.number = true
set.relativenumber = true
```