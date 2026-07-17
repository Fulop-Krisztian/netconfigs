---
title: Lua
tags:
  - programming
  - script
---
Run lua
---

To run the current file:
`source %`

To run a line, select it in visual selection mode, and run it with the `lua` command

## The syntax

https://devhints.io/lua
Variables
---

source:
https://www.youtube.com/watch?v=CuWfgiwI73Q

```lua
-- this is a comment
local number = 5
local string = "hello"
local string = 'this is the same as before'
local multiline = [[ This is a multiline
string. This is insane
]]
--[[ this is a multiline 
comment.]] 

local this, that = true, false
local nothing = nil

```
#### Functions

```lua
local function hello(name)
	print("Hello!", name)
-- don't forget tht closing end on the function
end

-- this works in lua
local greet = function(name)
	-- .. is string concatenation
	print("Greetings, " .. name .. "!")

```

```lua
-- This works too
local higher_order = function(value)
	return function(another)
		return value + another
	end
end

-- So we can assign a function to a variable
local add_one = higher_order(1)
print("add_one(2) -> ", add_one(2))


```
#### Tables
Actually everything in lua is a table (similar to how in [[bash]] everything is just a list. I think)

```lua
local list = { "First", 2, false, function() print("Fourth!") end }
print("1 indexed nightmare:", list[1]) -- this will print first
```
#### Maps

```lua
local t = {
	literal_key = "a string",
	["an expression"] = "also works",
	[function() end] = true
}

print("literal key:", t.literal_key)
print("expression:", t["an expression"])
print("function:", t[function() end]) -- This will not actually print true, because this is a separate function declaration, so this is not the same as the function that was defined when we defined 't'
```

Other types of variables:
- Thread ([Coroutine](https://www.lua.org/pil/9.1.html) library if interested)
- Userdata

These are not covered

Control flow
---

#### For
##### For loops over tables

```lua
local things = {"thing1", "thing2", "thing3"}

-- The # operator in lua returns the length of a table.
-- So here it's going to be 3
-- The loop goes from 1 to 3
for index = 1, #things do
	print(index, things[index])
end

-- But this way is cleaner I think
for index, value in ipairs(things) do
	print(index, value)
end
```

> [!IMPORTANT]  
> For maps, this doesn't work. For that you will have to use...
##### For loops over maps

```lua
local map_thing = { a = 1.2, b =3.5 }
-- quite a nice syntax
for key, value in pairs(map_thing) do
	print(key, value)
end
```

#### If

```lua
local function action(loves_coffee)
	if loves_coffee then
		print("yeah")
	else
		print("nah")
	-- end for the if
	end
-- end for the function
end

--false values:
action()
action(nil) -- this is the same as the previous actually
action(false)

-- Everything else is true. Even 0. Even an empty table {}.
```

Modules (imports)
---

It's just a convention.

lua files are just really big functions effectively.

```lua
-- file1.lua
local M = {}
M.cool_function = function() end
return M
```

We now have a table called M, which has the cool_function, which we return at the end of the file.

We can import this file into another lua file with the `require()` keyword. This doesn't actually splice the code into the file, takes the return value from file1 and puts it into a variable.

```lua
-- file2.lua
local file1 = require('file1')
file1.cool_function()
```

Function shenanigans
---
#### Multiple returns

Yeah, this exists.

```lua
local returns_four_values = function()
	return 1, 2, 3, 4 
end

first, second, third = returns_four_values()
-- '4' is discraded

-- I think this should work
print(first, second, third)

```

#### Variadic functions

```lua
local variable_arguments = function(...)
	local arguments = {...}
	for i, v in ipairs({...}) do print(i,v) end
	return unpack(arguments)
end

print("=======")
print("1:", variable_arguemnts("hello", "world", "!"))
print("=======")
-- The world and ! get dropped after the hello here.
print("2:", variable_arguemnts("hello", "world", "!"), "<list>")


```

#### shorthand for calling functions with LITERAL STRINGS

Yeah... this works.
```lua
local test = function(s)
	return s.. " wow!"
end


local x = test("hi")
local y = test "hi"
print(x, y)

```

#### shorthand for calling functions with LITERAL TABLES

```lua
local setup = function(opts)
	if opts.default == nil then opts.default = 17 end
	
	print(opts.default, opts.other)
end

-- the function can be called like this too
setup { default = 12, other = false }
setup { other = true }

```

#### Colon functions

[[#metatables]]

```lua
local MyTable = {}

function MyTable.something(self, ...) end
function MyTable:something(...) end
-- These two lines are equivalent
```


Metatables
---

Similar to trait implementations in rust, or operator overloading in C++.

```lua
local vector_mt = {}

vector_mt.__add = function(left,right)
	return setmetatable({
	left[1] + right[1],
	left[2] + right[2],
	left[3] + right[3],
	}, vector_mt)
end

local v1 = setmetatable({3, 1, 5}, vector_mt)
local v2 = setmetatable({-3, 2, 2}, vector_mt)
local v3 = v1 + v2

print(v3[1], v3[2], v3[3])
print(v3 + v3)
```

```lua
local fib_mt = {
	-- The index function gets called when we're trying to index into an element of the table that doesn't exist
	__index = function(self, key)
		if key < 2 then return 1 end
		-- update the table to save the intermediate results
		self[key] = self[key - 2] + self[key - 1]
		--return the result
		return self[key]
	end
	
	-- __newindex(self, key, value)
	-- This one is called when a new element is created
	
	-- __call(self, ...)
	-- You can call a table like you would a function, and this is what would run in that case
}

local fib = setmetatable({}, fib_mt)
print(fib[5])
print(fib[1000])
```


Bringing it together
---

This is the VIM part

```lua
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<.CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
```

```lua
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
	callback = function()
		vim.highlight.on_yank()
	end,
})

```