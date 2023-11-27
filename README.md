# Moplex🔥
Complex types for Mojo🔥

Moplex provides generalized complex numbers for the mojo programming language.

Complex numbers have a real and imaginary part which can be added, multiplied, and exponentiated.

`5 + 4i`

The imaginary part multiplied by itself is -1

`i*i = -1`

# Generalized Complex

Moplex also has **Paraplex** numbers (also called dual numbers), and **Hyperplex** numbers (also called hyperbolic numbers)

They are similar in that they also square to a real number:

Paraplex, written like `3+1o`, squares to zero -> `o*o = 0`

Hyperplex, written like `1+2o`, squares to one -> `x*x = 0`

In Moplex, all three of these type are considered the `unital hybrids`, and the imaginary part is considered the `antiox`

You can in fact make a number which has an antiox that squares to any real by parameterizing the `Hybrid` type.

This looks like: `HybridInt[-2](0,1)`, which squares to `-2`

# Multiplex

When adding two HybridSIMD types with differing antiox squares, it will result in a **Multiplex** type

Example: `(1 + 1i) + (2 + 2o) = (2 + 1i + 2o)` 

