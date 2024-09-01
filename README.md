# Moplex🔥
Generalized Complex Numbers for Mojo🔥

Mojo nightly version: `mojo 2024.9.105 (a4c61bf1)`

Moplex provides generalized complex numbers for the mojo programming language.

Complex numbers have a real and imaginary part which can be added, multiplied, exponentiated, and more.

`5 + 4i`

The imaginary part multiplied by itself is -1

`i*i = -1`

# Generalized Complex

Moplex also has **Dualplex** numbers (also called dual numbers), and **Hyperplex** numbers (also called split numbers)

In Moplex, all three of these type are considered the `unital hybrids`, and the imaginary part is considered the `antiox`

They are similar to complex, in that the antiox also squares to a real number:

Dualplex numbers, written like `3+1o`, has an antiox that squares to zero -> `o*o = 0`

Hyperplex numbers, written like `1+2x`, have an antiox that squares to one -> `x*x = 1`



You can even make a number with an antiox that squares to any real by parameterizing the `Hybrid` type.

This looks like: `HybridInt[-2](0,1)`, which squares to `-2`

# Multiplex

When adding two HybridSIMD types with differing antiox squares, it will result in a **Multiplex** type

Example: `(1 + 1i) + (2 + 2o) = (3 + 1i + 2o)` 

# Using in Mojo

to import and use a type, you can do:

```mojo
from moplex import *
from moplex import i, o, x

print(Complex64(-1,-2) ** i)
print(Dualplex64(1,1) + o)
print(Hyperplex64(8,6) * x)
print(Complex64(-1,-2) + Dualplex64(1,1) + Hyperplex64(8,6))
```

You can also import just the antiox parts, but this is not ideal as some people like using single letter variables for other things.  
Also, they dont sum together yet due to them being HybridIntLiteral type. (only MultiplexSIMD for now)  
This may change with future updates.