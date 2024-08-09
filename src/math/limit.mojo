# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Numerical Limits."""

from collections import Optional
from math.math import nan as _nan
from math.math import isnan as _isnan

alias NAN: FloatLiteral = __mlir_attr[`#kgen.float_literal<nan>`]
alias INF: FloatLiteral = __mlir_attr[`#kgen.float_literal<inf>`]


@always_inline
fn nan[
    type: DType, size: Int = 1, fail: Optional[SIMD[type, 1]] = None
]() -> SIMD[type, size]:
    @parameter
    if type.is_floating_point():
        return _nan[type]()
    constrained[fail.__bool__(), "cannot get nan of integral dtype"]()
    return fail.value()


@always_inline
fn nan_hybrid[
    type: DType,
    square: FloatLiteral,
    size: Int = 1,
    fail: Optional[HybridSIMD[type, 1, square]] = None,
]() -> HybridSIMD[type, size, square]:
    @parameter
    if type.is_floating_point():
        return (_nan[type](), _nan[type]())
    constrained[fail.__bool__(), "cannot get nan of integral dtype"]()
    return fail.value()


@always_inline
fn nan_multiplex[
    type: DType, size: Int = 1, fail: Optional[MultiplexSIMD[type, 1]] = None
]() -> MultiplexSIMD[type, size]:
    @parameter
    if type.is_floating_point():
        return MultiplexSIMD[type, 1](
            _nan[type](), _nan[type](), _nan[type](), _nan[type]()
        )
    constrained[fail.__bool__(), "cannot get nan of integral dtype"]()
    return fail.value()


@always_inline
fn isnan(value: FloatLiteral) -> Bool:
    return __mlir_op.`kgen.float_literal.cmp`[
        pred = __mlir_attr.`#kgen<float_literal.cmp_pred ne>`
    ](value.value, value.value)


@always_inline
fn isnan(value: SIMD) -> SIMD[DType.bool, value.size]:
    return _isnan(value)


@always_inline
fn isnan_hybrid[
    type: DType, size: Int, square: FloatLiteral
](value: HybridSIMD[type, size, square]) -> SIMD[DType.bool, size]:
    return any(_isnan(value.re)) or any(_isnan(value.im))


# @always_inline
# fn isnan_multiplex(value: MultiplexSIMD) -> SIMD[DType.bool, value.size]:
#     return _isnan(value.s) or _isnan(value.i) or _isnan(value.o) or _isnan(value.x)
