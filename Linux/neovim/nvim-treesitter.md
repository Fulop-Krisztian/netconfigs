---
title: Treesitter
tags:
---
https://github.com/nvim-treesitter/nvim-treesitter

Okay so treesitter is the thing that does syntax highlighting pretty much (it handles the parsing and everything).

It's included in nvim by default, but you would have to add parsers and things manually which is a chore (there are a LOT of languages out there)

So for this reason there exists a certain `nvim-treesitter/nvim-treesitter` plugin, which did more in the past, but right now it's basically relegated to installing syntax highlights for the given languages.

> [!NOTE]  
> nvim development is quite chaotic, and a bunch of features got integrated into base nvim at one point from this plugin. The plugin devs decided to scale back `nvim-treesitter`, and now it's just a de-facto package manager for parsers.
> 
> With this, the whole method of configuration changed, and most things still reference the old way of doing things (like the advent of neovim series which I'm using to learn nvim). Look out for this because it's pretty confusing

Configure
---

An example config (under `~./config/nvim/lua/plugins/treesitter.lua`)
This uses the lazy.nvim plugin manager.

```lua
return {
    {
	'nvim-treesitter/nvim-treesitter',
    	lazy = false,
    	build = ':TSUpdate',
	config = function()
	    local ts = require('nvim-treesitter');
	    -- This is the default anyways.
	    ts.setup {
		-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
		install_dir = vim.fn.stdpath('data') .. '/site'
	    };

	    ts.install { 
		'rust', 'c', 'cpp', 							-- low level
		'python', 'bash', 'go', 'powershell', 'sql',				-- high level
		'json', 'yaml', 'toml', 'xml', 'ini',					-- markup
		'dockerfile', 'make', 'cmake',						-- devops
		'php', 'javascript', 'typescript', 'jsx', 'tsx', 'css', 'html', 	-- web
		'nginx', 'passwd', 'ssh_config', 'hyprlang'				-- config
	    };
	end,
    },
}
```

It's pretty self-explanatory.

To see if the parsers actually installed use `checkhealth nvim-treesitter`

In the output the H L F I J indicates what features are implemented for each parser
- Highlights
- Locals
- Folds (collapse)
- Indents
- Injections (SQL in Python or JS in HTML for examle)

A tick means that it's present, a dot means that it's not applicable to the language


Enable
---
