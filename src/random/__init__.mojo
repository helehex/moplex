# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #
"""Implements the moplex random module.

Defines random generalized complex values.
"""

from memory import stack_allocation
from random import rand as _rand


# +------( Random )------+ #
#
fn rand[type: DType, size: Int]() -> SIMD[type, size]:
    var p: UnsafePointer[Scalar[type]] = stack_allocation[size, Scalar[type]]()
    _rand(p, size)
    return SIMD[type, size].load(p)


fn rand[
    type: DType, size: Int, square: FloatLiteral
]() -> HybridSIMD[type, size, square]:
    return HybridSIMD[type, size, square](
        rand[type, size](), rand[type, size]()
    )


fn coin() -> Bool:
    return rand[DType.index, 1]() < 0


# +------( Random Sign )------+ #
#
from ..math import select


fn random_sign[type: DType, size: Int]() -> SIMD[type, size]:
    @parameter
    if type.is_unsigned():
        return 1
    return simd_select[type](rand[DType.index, size]() < 0, -1, 1)


fn random_sign[
    type: DType, size: Int, square: FloatLiteral
]() -> HybridSIMD[type, size, square]:
    """
    Returns a random hybrid number with measure equal to 1.
    """
    # define integral type to return either {1, -1, i, -i}

    var theta = rand[type, size]() * tau
    var result = expa[square](theta)

    @parameter
    if square < 0:
        return result
    else:
        return HybridSIMD[type, size, square](
            result.re * random_sign[type, size](),
            result.im * random_sign[type, size](),
        )


# +------( Random Value )------+ #
#
# --- random value with measure less than 1
#
fn random_frac[type: DType, size: Int]() -> SIMD[type, size]:
    return (rand[type, size]() * 2) - 1


fn random_frac[
    type: DType, size: Int, square: FloatLiteral
]() -> HybridSIMD[type, size, square]:
    # change densities
    @parameter
    if square == -1:
        return sqrt(rand[type, size]()) * random_sign[type, size, square]()
    if square == 0:
        return rand[type, size]() * random_sign[type, size, square]()
    else:
        return (rand[type, size]() ** 2) * random_sign[type, size, square]()
