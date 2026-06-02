---
title: Lazy.nvim
tags:
---
This is a package manager for neovim.

https://lazy.folke.io/installation


Lazy.nvim's job is pretty much importing specs from a folder (from plugins by default) which describe what you want, and then pulling those packages.


A template for a config file:
```
return {
    {
	"neovim/nvim-lspconfig",
	config = function()

	end,
    }
}
```