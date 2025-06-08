---
title: Arrays in Rust (Vector)
tags:
  - programming
  - rust
  - basic
---
Terminology, general knowledge
---
- Vectors can only store a single type of data
- Allocated on the heap (meaning it's kind of slow)
- Mutability and scope rules apply as usual
- You can add or remove elements at your leisure

Sources
---
[Rust book chapter 8](https://doc.rust-lang.org/book/ch08-01-vectors.html)

[Rust API documentation](https://doc.rust-lang.org/std/vec/struct.Vec.html#)

Examples
---
### Creating a vector

This can be done in multiple ways:

> [!NOTE]  
> The best practice is to create a vector, and specify the smallest size that you expect it to not exceed. You should read about this in the API documentation, since this is a pretty important thing about a fundamental data structure:
> https://doc.rust-lang.org/std/vec/struct.Vec.html#capacity-and-reallocation

```rust
// The best practice
let mut vec = Vec::with_capacity(10);

// This creates a vector with a capacity for 10 items
// (actual memory allocation is based on item_type_size*capacity.)
// If you add an 11th element to the vector, it will still work,
// though the memory has to be reallocated, and that casuses slowdowns.
```

```rust
// Creating an empty vector. You cannot modify this!
let v: Vec<i32> = Vec::new();
```

```rust
// Creating an empty vector you can actually modify
let mut v: Vec<i32> = Vec::new();
```

You can also use the vec! macro:

```rust
// Creating a vector with data. You can still only have a single type of data here, but it's inferred.
let v = vec![1, 2, 3];
```

### Indexing (reading elements)

Best practice is to use `vectorname.get(index)` instead of just `v[index]`. 

This is because `.get()` returns an `Option<>`, which you can use to check if the index actually returned a value, or if the index is out of range. If you use `v[index]`, and the index you requested is out of range, then the program just panics.

```rust
let v = vec![1, 2, 3, 4, 5];

// Raw indexing. Panics may happen if out of range.
let third: &i32 = &v[2];
println!("The third element is {third}");

// Using options with .get()
let third: Option<&i32> = v.get(2);
match third {
	Some(third) => println!("The third element is {third}"),
	None => println!("There is no third element."),
}
```