# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #
"""Implements Complex, Dualplex, Hyperplex, and Multiplex types, backed by Hybrid.

Hybrid is parameterized on the unit antiox squared.

Complex, Dualplex, and Hyperplex are the three unitized hybrid types.

Multiplex is a composition of the three unitized hybrid types.
"""

from ..math import *
from ..io import *
from .hybrid_int_literal import *
from .hybrid_float_literal import *
from .hybrid_int import *
from .hybrid_simd import *
from .multiplex_simd import *

alias i = ComplexInt(0,1)
alias o = DualplexInt(0,1)
alias x = HyperplexInt(0,1)

# next rework:
# explore parameterizing things on masks and signatures, less hard-coded types


trait FnMin:
    fn __min__(self, other: Self) -> Self: ...


trait FnMax:
    fn __max__(self, other: Self) -> Self: ...


trait FnAdd:
    fn __add__(self, other: Self) -> Self: ...


trait FnSub:
    fn __sub__(self, other: Self) -> Self: ...


trait Scalable:
    fn __mul__(self, other: Scalar) -> Self: ...
    fn __rmul__(self, other: Scalar) -> Self: ...
    fn __truediv__(self, other: Scalar) -> Self: ...
    fn __floordiv__(self, other: Scalar) -> Self: ...


trait Linear(FnAdd, FnSub, Scalable):
    pass


trait Arithmatic(Linear):
    fn __mul__(self, other: Self) -> Self: ...
    fn __truediv__(self, other: Self) -> Self: ...
    fn __rtruediv__(self, other: Scalar) -> Self: ...
    fn __floordiv__(self, other: Self) -> Self: ...
    fn __rfloordiv__(self, other: Scalar) -> Self: ...


# trait HybridIntable[square: FloatLiteral]:
#     fn __hybridint__(self) -> HybridInt[square]: ...
