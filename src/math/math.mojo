# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Implements the moplex math module.

Defines generalized complex math functions.
"""

from os import abort
from .solver import newtons_method


# +----------------------------------------------------------------------------------------------+ #
# | Select
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")  # Scalar _ Scalar
fn select[
    type: DType, size: Int
](
    cond: SIMD[DType.bool, size],
    true_case: SIMD[type, size],
    false_case: SIMD[type, size],
) -> SIMD[
    type, size
]:
    """
    Selects the hybrid elements of the true_case or the false_case based on the input boolean values of the given SIMD vector.

    Parameters:
        type: The element type of the input and output SIMD vectors.
        size: Width of the SIMD vectors we are comparing.

    Args:
        cond: The vector of bools to check.
        true_case: The values selected if the positional value is True.
        false_case: The values selected if the positional value is False.

    Returns:
        A new vector of the form [true_case[i] if cond[i] else false_case[i] in enumerate(self)].
    """
    return cond.select(true_case, false_case)


@always_inline("nodebug")  # Scalar _ Hybrid
fn select[
    type: DType, size: Int, square: FloatLiteral
](
    cond: SIMD[DType.bool, size],
    true_case: SIMD[type, size],
    false_case: HybridSIMD[type, size, square],
) -> HybridSIMD[type, size, square]:
    """
    Selects the hybrid elements of the true_case or the false_case based on the input boolean values of the given SIMD vector.

    Parameters:
        type: The element type of the input and output SIMD vectors.
        size: Width of the SIMD vectors we are comparing.
        square: The hybrid antiox squared.

    Args:
        cond: The vector of bools to check.
        true_case: The values selected if the positional value is True.
        false_case: The values selected if the positional value is False.

    Returns:
        A new vector of the form [true_case[i] if cond[i] else false_case[i] in enumerate(self)].
    """
    return HybridSIMD[type, size, square](
        select(cond, true_case, false_case.re),
        select(cond, 0, false_case.im),
    )


@always_inline("nodebug")  # Hybrid _ Scalar
fn select[
    type: DType, size: Int, square: FloatLiteral
](
    cond: SIMD[DType.bool, size],
    true_case: HybridSIMD[type, size, square],
    false_case: SIMD[type, size],
) -> HybridSIMD[type, size, square]:
    """
    Selects the hybrid elements of the true_case or the false_case based on the input boolean values of the given SIMD vector.

    Parameters:
        type: The element type of the input and output SIMD vectors.
        size: Width of the SIMD vectors we are comparing.
        square: The hybrid antiox squared.

    Args:
        cond: The vector of bools to check.
        true_case: The values selected if the positional value is True.
        false_case: The values selected if the positional value is False.

    Returns:
        A new vector of the form [true_case[i] if cond[i] else false_case[i] in enumerate(self)].
    """
    return HybridSIMD[type, size, square](
        select(cond, true_case.re, false_case),
        select(cond, true_case.im, 0),
    )


@always_inline("nodebug")  # Hybrid _ Hybrid
fn select[
    type: DType, size: Int, square: FloatLiteral
](
    cond: SIMD[DType.bool, size],
    true_case: HybridSIMD[type, size, square],
    false_case: HybridSIMD[type, size, square],
) -> HybridSIMD[type, size, square]:
    """
    Selects the hybrid elements of the true_case or the false_case based on the input boolean values of the given SIMD vector.

    Parameters:
        type: The element type of the input and output SIMD vectors.
        size: Width of the SIMD vectors we are comparing.
        square: The hybrid antiox squared.

    Args:
        cond: The vector of bools to check.
        true_case: The values selected if the positional value is True.
        false_case: The values selected if the positional value is False.

    Returns:
        A new vector of the form [true_case[i] if cond[i] else false_case[i] in enumerate(self)].
    """
    return HybridSIMD[type, size, square](
        select(cond, true_case.re, false_case.re),
        select(cond, true_case.im, false_case.im),
    )


# +----------------------------------------------------------------------------------------------+ #
# | Square Root
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn sqrt(value: IntLiteral) -> IntLiteral:
    """Returns the square root of the input IntLiteral."""
    if value <= 1:
        return value
    var a: IntLiteral = value // 2
    var b: IntLiteral = (a + value // a) // 2
    while b < a:
        a = b
        b = (a + value // a) // 2
    return a


@always_inline("nodebug")
fn sqrt[type: DType, size: Int, //, value: SIMD[type, size]]() -> SIMD[type, size]:
    """Returns the square root of the input simd vector."""

    @parameter
    if type.is_floating_point():
        return select(value == 0, 0, 1 / rsqrt[value]())
    var negative = (value <= 0)
    var finished = (negative) | (value == 1)
    var a = select(negative, -1, (value + 1) / 2)
    while not finished:
        var b = (a + value / a) / 2
        finished |= b >= a
        a = select(finished, a, b)
    return select(negative, 0, a)


@always_inline("nodebug")
fn sqrt(value: FloatLiteral) -> FloatLiteral:
    """Returns the square root of the input FloatLiteral. This may change."""
    return 1 / rsqrt(value)


@always_inline("nodebug")
fn sqrt(value: Int) -> Int:
    """
    Performs square root on an integer.

    Args:
        value: The integer value to perform square root on.

    Returns:
        The square root of x.
    """
    from math import sqrt as _sqrt

    return _sqrt(value)


@always_inline("nodebug")
fn sqrt(value: SIMD) -> __type_of(value):
    """
    Performs elementwise square root on the elements of a SIMD vector.

    Args:
        value: SIMD vector to perform square root on.

    Returns:
        The elementwise square root of x.
    """
    from math import sqrt as _sqrt

    return _sqrt(value)


@always_inline("nodebug")
fn sqrt[branch: IntLiteral = 0](value: HybridSIMD) -> __type_of(value):
    return value.__pow__[branch](0.5)


# +----------------------------------------------------------------------------------------------+ #
# | Reciprocal Square Root
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn rsqrt[type: DType, size: Int, //, value: SIMD[type, size]]() -> SIMD[type, size]:
    """Returns the reciprocal square root of the input simd vector."""

    @parameter
    if type.is_integral():
        return 0
    var negative = value <= 0
    var finished = negative | (value == 1)
    var a = select[type](negative, nan, 2 / (value + 1))
    while not finished:
        var b = (a / 2) * (3 - value * a * a)
        finished |= b <= a
        a = select(finished, a, b)
    return a


@always_inline("nodebug")
fn rsqrt(value: FloatLiteral) -> FloatLiteral:
    """Returns the reciprocal square root of the input FloatLiteral. This may change."""

    @parameter
    fn f(value: FloatLiteral) -> FloatLiteral:
        return 1 / (value * value)

    @parameter
    fn df(value: FloatLiteral) -> FloatLiteral:
        return -2 / (value * value * value)

    return newtons_method[f, df, 8, 1e-8](2 / (value + 1), value)


@always_inline("nodebug")
fn rsqrt(value: SIMD) -> __type_of(value):
    """
    Performs elementwise reciprocal square root on the elements of a SIMD vector.

    Args:
        value: SIMD vector to perform reciprocal square root on.

    Returns:
        The elementwise reciprocal square root of x.
    """
    from math import isqrt as _rsqrt

    return _rsqrt(value)


@always_inline("nodebug")
fn rsqrt[branch: IntLiteral = 0](value: HybridSIMD) -> __type_of(value):
    return value.__pow__[branch](-0.5)


# +----------------------------------------------------------------------------------------------+ #
# | Exponential
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn exp_[atol: FloatLiteral = 0.1e-20](owned val: FloatLiteral) -> FloatLiteral:
    var result: FloatLiteral = 1.0
    var count: IntLiteral = 1
    var term: FloatLiteral = val
    while abs(term) > atol:
        result += term
        count += 1
        term *= val / count
    return result


@always_inline("nodebug")
fn exp(value: HybridFloatLiteral) -> __type_of(value):
    """
    Hybrid exponential.

    Calculates elementwise e^Hybrid_i, where Hybrid_i is an element in the input SIMD vector at position i.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Hybrid_i, where Hybrid_i is an element in the input SIMD vector.
    """
    return exp_(value.re) * hexp[value.square](value.im)


@always_inline("nodebug")
fn exp(value: SIMD) -> __type_of(value):
    """
    Calculates elementwise e^{X_i}, where X_i is an element in the input SIMD vector at position i.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Xi where Xi is an element in the input SIMD vector.
    """
    from math import exp as _exp

    return _exp(value)


# change to use antiox type?
@always_inline("nodebug")
fn hexp[square: FloatLiteral](value: FloatLiteral) -> HybridFloatLiteral[square]:
    """
    Antiox exponential.

    Calculates elementwise e^{Antiox(X_i)}, where X_i is an element in the input SIMD vector at position i.

    Parameters:
        square: The antiox squared.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Antiox(Xi) where Xi is an element in the input SIMD vector.
    """

    @parameter
    if square == -1:
        abort("not implemented")
        return 0
        # return HybridFloatLiteral[square](cos(value), sin(value))
    elif square == 0:
        return HybridFloatLiteral[square](1, value)
    elif square == 1:
        abort("not implemented")
        return 0
        # return HybridFloatLiteral[square](cosh(value), sinh(value))
    else:
        alias factor = ufac(square)
        var result: HybridFloatLiteral[sign(square)] = hexp[sign(square)](value * factor)
        return HybridFloatLiteral[square](result.re, result.im / factor)


# change to use antiox type?
@always_inline("nodebug")
fn hexp[square: FloatLiteral](value: SIMD) -> HybridSIMD[value.type, value.size, square]:
    """
    Antiox exponential.

    Calculates elementwise e^{Antiox(X_i)}, where X_i is an element in the input SIMD vector at position i.

    Parameters:
        square: The antiox squared.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Antiox(Xi) where Xi is an element in the input SIMD vector.
    """

    @parameter
    if square == -1:
        return HybridSIMD[value.type, value.size, square](cos(value), sin(value))
    elif square == 0:
        return HybridSIMD[value.type, value.size, square](1, value)
    elif square == 1:
        return HybridSIMD[value.type, value.size, square](cosh(value), sinh(value))
    else:
        alias factor = ufac(square)
        var result = hexp[sign(square)](value * factor)
        return HybridSIMD[value.type, value.size, square](result.re, result.im / factor)


@always_inline("nodebug")
fn exp(value: HybridSIMD) -> __type_of(value):
    """
    Hybrid exponential.

    Calculates elementwise e^Hybrid_i, where Hybrid_i is an element in the input SIMD vector at position i.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Hybrid_i, where Hybrid_i is an element in the input SIMD vector.
    """
    return exp(value.re) * hexp[value.square](value.im)


# +----------------------------------------------------------------------------------------------+ #
# | Power
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn pow_(owned lhs: FloatLiteral, owned rhs: IntLiteral) -> FloatLiteral:
    if lhs == 0:
        return 1
    elif rhs < 16:
        while rhs > 1:
            lhs *= lhs
            rhs -= 1
        return lhs
    else:
        if lhs <= 0:
            return pow_(-lhs, FloatLiteral(rhs)) * (1 - ((rhs % 2) * 2))
        else:
            return pow_(lhs, FloatLiteral(rhs))


@always_inline("nodebug")
fn pow_(owned lhs: FloatLiteral, owned rhs: FloatLiteral) -> FloatLiteral:
    return exp_(rhs * log_(lhs))


# +----------------------------------------------------------------------------------------------+ #
# | Logarithm
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn log_[atol: FloatLiteral = 0.1e-20](owned val: FloatLiteral) -> FloatLiteral:
    if val <= 0:
        return nan
    var term: FloatLiteral = (val - 1) / (val + 1)
    var ratio: FloatLiteral = term * term
    var count: FloatLiteral = 1
    var result: FloatLiteral = term
    while abs(term) > atol:
        term *= ratio
        count += 2
        result += term / count
    return 2 * result


@always_inline("nodebug")
fn log[branch: IntLiteral = 0](owned val: HybridFloatLiteral) -> __type_of(val):
    """
    Performs elementwise natural log (base E) of a `HybridFloatLiteral`.

    Args:
        val: The hybrid number to perform logarithm operation on.

    Returns:
        The result of performing natural log base E on x.
    """
    return __type_of(val)(val.lmeasure[True](), val.argument[branch]())


@always_inline("nodebug")
fn log(value: SIMD) -> __type_of(value):
    """
    Performs elementwise natural log (base E) of a SIMD vector.

    Args:
        value: Vector to perform logarithm operation on.

    Returns:
        Vector containing result of performing natural log base E on x.
    """
    from math import log as _log

    return _log(value)


@always_inline("nodebug")
fn log[branch: IntLiteral = 0](value: HybridSIMD) -> __type_of(value):
    """
    Performs elementwise natural log (base E) of a HybridSIMD vector.

    Args:
        value: Vector to perform logarithm operation on.

    Returns:
        Vector containing result of performing natural log base E on x.
    """
    return __type_of(value)(value.lmeasure[True](), value.argument[branch]())


# +----------------------------------------------------------------------------------------------+ #
# | Lambert W
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn _xex(value: HybridSIMD) -> __type_of(value):
    return value * exp(value)


@always_inline("nodebug")
fn _dxex(value: HybridSIMD) -> __type_of(value):
    var ex = exp(value)
    return ex + value * ex


@always_inline("nodebug")
fn lw[branch: IntLiteral = 0](value: HybridSIMD) -> __type_of(value):
    """
    Computes the elementwise Lambert W function of a HybridSIMD vector.

    The Lamber W function is defined as: `lw(x*(e**x)) = x` for a variable x.

    Parameters:
        branch: The multivalue branch to propagate.

    Args:
        value: HybridSIMD vector to perform lambert w on.

    Returns:
        HybridSIMD Vector containing the results.
    """
    var guess: __type_of(value)

    @parameter
    if branch == -1:
        guess = log(-value) * 2
    else:
        guess = log[branch=branch](value + 1)

    return newtons_method[_xex, _dxex, 8, 1e-8](guess, value)


# +----------------------------------------------------------------------------------------------+ #
# | Sine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn sin(value: SIMD) -> __type_of(value):
    """Computes sine of the input."""
    from math import sin as _sin

    return _sin(value)


@always_inline("nodebug")
fn sin(value: HybridSIMD) -> __type_of(value):
    """Computes sine of the input."""

    @parameter
    if value.square == -1:
        return __type_of(value)(sin(value.re) * cosh(value.im), cos(value.re) * sinh(value.im))
    elif value.square == 0:
        return __type_of(value)(sin(value.re), cos(value.re) * value.im)
    elif value.square == 1:
        return __type_of(value)(sin(value.re) * cos(value.im), cos(value.re) * sin(value.im))
    else:
        return sin(value.unitize()).unitize[value.square]()


# +----------------------------------------------------------------------------------------------+ #
# | Cosine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn cos(value: SIMD) -> __type_of(value):
    """Computes cosine of the input."""
    from math import cos as _cos

    return _cos(value)


@always_inline("nodebug")
fn cos(value: HybridSIMD) -> __type_of(value):
    """Computes cosine of the input."""

    @parameter
    if value.square == -1:
        return __type_of(value)(cos(value.re) * cosh(value.im), -sin(value.re) * sinh(value.im))
    elif value.square == 0:
        return __type_of(value)(cos(value.re), -sin(value.re) * value.im)
    elif value.square == 1:
        return __type_of(value)(cos(value.re) * cos(value.im), -sin(value.re) * sin(value.im))
    else:
        return cos(value.unitize()).unitize[value.square]()


# +----------------------------------------------------------------------------------------------+ #
# | Tangent
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn tan(value: SIMD) -> __type_of(value):
    """Computes tangent of the input."""
    from math import tan as _tan

    return _tan(value)


@always_inline("nodebug")
fn tan(value: HybridSIMD) -> __type_of(value):
    """Computes tangent of the input."""

    @parameter
    if value.square == -1:
        return __type_of(value)(sin(2 * value.re), sinh(2 * value.im)) / (
            cos(2 * value.re) + cosh(2 * value.im)
        )
    elif value.square == 0:
        return __type_of(value)(tan(value.re), (sec(value.re) ** 2) * value.im)
    elif value.square == 1:
        return __type_of(value)(sin(2 * value.re), sin(2 * value.im)) / (
            cos(2 * value.re) + cos(2 * value.im)
        )
    else:
        return tan(value.unitize()).unitize[value.square]()


# +----------------------------------------------------------------------------------------------+ #
# | Cotangent
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn cot(value: SIMD) -> __type_of(value):
    """Computes cotangent of the input."""
    return tan((pi / 2) - value)


@always_inline("nodebug")
fn cot(value: HybridSIMD) -> __type_of(value):
    """Computes cotangent of the input."""

    @parameter
    if value.square == -1:
        return (cos(2 * value.re) + cosh(2 * value.im)) / __type_of(value)(
            sin(2 * value.re), sinh(2 * value.im)
        )
    elif value.square == 0:
        return __type_of(value)(cot(value.re), -(csc(value.re) ** 2) * value.im)
    elif value.square == 1:
        return (cos(2 * value.re) + cos(2 * value.im)) / __type_of(value)(
            sin(2 * value.re), sin(2 * value.im)
        )
    else:
        return cot(value.unitize()).unitize[value.square]()


# +----------------------------------------------------------------------------------------------+ #
# | Secant
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn sec(value: SIMD) -> __type_of(value):
    """Computes secant of the input."""
    return 1 / cos(value)


@always_inline("nodebug")
fn sec(value: HybridSIMD) -> __type_of(value):
    """Computes secant of the input."""
    return 1 / cos(value)


# +----------------------------------------------------------------------------------------------+ #
# | Cosecant
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn csc(value: SIMD) -> __type_of(value):
    """Computes cosecant of the input."""
    return 1 / sin(value)


@always_inline("nodebug")
fn csc(value: HybridSIMD) -> __type_of(value):
    """Computes cosecant of the input."""
    return 1 / sin(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Sine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn sinh(value: SIMD) -> __type_of(value):
    """Computes hyperbolic sine of the input."""
    from math import sinh as _sinh

    return _sinh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Cosine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn cosh(value: SIMD) -> __type_of(value):
    """Computes hyperbolic cosine of the input."""
    from math import cosh as _cosh

    return _cosh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Tangent
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn tanh(value: SIMD) -> __type_of(value):
    """Computes hyperbolic tangent of the input."""
    from math import tanh as _tanh

    return _tanh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Cotangent
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn coth(value: SIMD) -> __type_of(value):
    """Computes hyperbolic cotangent of the input."""
    return 1 / tanh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Secant
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn sech(value: SIMD) -> __type_of(value):
    """Computes hyperbolic secant of the input."""
    return 1 / cosh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Cosecant
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn csch(value: SIMD) -> __type_of(value):
    """Computes hyperbolic cosecant of the input."""
    return 1 / sinh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Arcsine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn asin(value: SIMD) -> __type_of(value):
    """Computes the arcsine of the input."""
    from math import asin as _asin

    return _asin(value)


# +----------------------------------------------------------------------------------------------+ #
# | Arccosine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn acos(value: SIMD) -> __type_of(value):
    """Computes the arccosine of the input."""
    from math import acos as _acos

    return _acos(value)


# +----------------------------------------------------------------------------------------------+ #
# | Arctangent
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn atan(value: SIMD) -> __type_of(value):
    """Computes arctangent of the input."""
    from math import atan as _atan

    return _atan(value)


@always_inline("nodebug")
fn atan2(y: SIMD, x: __type_of(y)) -> __type_of(y):
    """Computes quadrant adjusted arctangent of the inputs."""
    from math import atan2 as _atan2

    return _atan2(y, x)


@always_inline("nodebug")
fn atan2(y: Int, x: Int) -> Float64:
    """Computes quadrant adjusted arctangent of the inputs."""
    return atan2(Float64(y), Float64(x))


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Arcsine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn asinh(value: SIMD) -> __type_of(value):
    """Computes the hyperbolic arcsine of the input."""
    from math import asinh as _asinh

    return _asinh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Arccosine
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn acosh(value: SIMD) -> __type_of(value):
    """Computes the hyperbolic arccosine of the input."""
    from math import acosh as _acosh

    return _acosh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Hyperbolic Arctangent
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn atanh(value: SIMD) -> __type_of(value):
    """Computes hyperbolic arctangent of the input."""
    from math import atanh as _atanh

    return _atanh(value)


# +----------------------------------------------------------------------------------------------+ #
# | Sign
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn sign(value: IntLiteral) -> IntLiteral:
    """Returns the sign {+, 0, -} of the input."""
    return compare(value, 0)


@always_inline("nodebug")
fn sign(value: FloatLiteral) -> FloatLiteral:
    """Returns the sign {+, 0, -} of the input."""
    return compare(value, 0)


@always_inline("nodebug")
fn sign(value: Int) -> Int:
    """Returns the sign {+, 0, -} of the input."""
    return compare(value, 0)


@always_inline("nodebug")
fn sign[type: DType, size: Int, //, value: SIMD[type, size]]() -> __type_of(value):
    """Returns the sign {+, 0, -} of the input."""

    @parameter
    if value > 0:
        return 1
    elif value < 0:
        return -1
    else:
        return 0


@always_inline("nodebug")
fn sign(value: SIMD) -> __type_of(value):
    """Returns the sign {+, 0, -} of the input."""
    return compare(value, 0)


# +----------------------------------------------------------------------------------------------+ #
# | Compare
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn compare(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    if a > b:
        return 1
    elif a < b:
        return -1
    return 0


@always_inline("nodebug")
fn compare(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    if a > b:
        return 1
    elif a < b:
        return -1
    return 0


@always_inline("nodebug")
fn compare(a: Int, b: Int) -> Int:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (SIMD[DType.index, 1](a > b) - SIMD[DType.index, 1](a < b)).value


@always_inline("nodebug")
fn compare[type: DType, size: Int, //, a: SIMD[type, size], b: __type_of(a)]() -> __type_of(a):
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (a > b).cast[type]() - (a < b).cast[type]()


@always_inline("nodebug")
fn compare(a: SIMD, b: __type_of(a)) -> __type_of(a):
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (a > b).cast[a.type]() - (a < b).cast[a.type]()


# +----------------------------------------------------------------------------------------------+ #
# | Unital Factor
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn ufac(square: FloatLiteral) -> FloatLiteral:
    if square == sign(square):
        return 1
    else:
        return sqrt(abs(square))


# +----------------------------------------------------------------------------------------------+ #
# | Contrast
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn contrast[square: FloatLiteral](value: FloatLiteral) -> FloatLiteral:
    @parameter
    if square == 0:
        return abs(value)
    else:
        return value * value


@always_inline("nodebug")
fn contrast(value: HybridFloatLiteral) -> FloatLiteral:
    """Uses the fastest way to compare two hybrid numbers."""

    @parameter
    if value.square == 0:
        return value.measure()
    else:
        return value.denomer()


@always_inline("nodebug")
fn contrast[square: FloatLiteral](value: IntLiteral) -> IntLiteral:
    @parameter
    if square == 0:
        return abs(value)
    else:
        return value * value


@always_inline("nodebug")
fn contrast(value: HybridIntLiteral) -> IntLiteral:
    """Uses the fastest way to compare two hybrid numbers."""

    @parameter
    if value.square == 0:
        return abs(value.re)
    else:
        return value.denomer()


@always_inline("nodebug")
fn contrast[square: FloatLiteral](value: Int) -> Int:
    @parameter
    if square == 0:
        return abs(value)
    else:
        return value * value


@always_inline("nodebug")
fn contrast(value: HybridInt) -> Int:
    """Uses the fastest way to compare two hybrid numbers."""

    @parameter
    if value.square == 0:
        return abs(value.re)
    else:
        return value.denomer()


@always_inline("nodebug")
fn contrast[square: FloatLiteral](value: SIMD) -> __type_of(value):
    @parameter
    if square == 0:
        return abs(value)
    else:
        return value * value


@always_inline("nodebug")
fn contrast(value: HybridSIMD) -> SIMD[value.type, value.size]:
    """Uses the fastest way to compare two hybrid numbers."""

    @parameter
    if value.square == 0:
        return value.measure()
    else:
        return value.denomer()


# +----------------------------------------------------------------------------------------------+ #
# | isnan
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline
fn isnan(value: FloatLiteral) -> Bool:
    return value.is_nan()


@always_inline
fn isnan(value: SIMD) -> SIMD[DType.bool, value.size]:
    from math import isnan as _isnan

    return _isnan(value)


@always_inline
fn isnan(value: HybridSIMD) -> SIMD[DType.bool, value.size]:
    return any(isnan(value.re)) or any(isnan(value.im))


@always_inline
fn isnan(value: MultiplexSIMD) -> SIMD[DType.bool, value.size]:
    return isnan(value.re) or isnan(value.i) or isnan(value.o) or isnan(value.x)


# +----------------------------------------------------------------------------------------------+ #
# | L1 Norm
# +----------------------------------------------------------------------------------------------+ #
#
@always_inline("nodebug")
fn l1norm(value: HybridSIMD) -> SIMD[value.type, value.size]:
    return abs(value.re) + abs(value.im)


@always_inline("nodebug")
fn l1norm(value: MultiplexSIMD) -> SIMD[value.type, value.size]:
    return abs(value.re) + abs(value.i) + abs(value.o) + abs(value.x)


# dont look, Int to IntLiteral workaround

# @always_inline("nodebug")
# fn to_int_literal[value: Int]() -> IntLiteral:
#     var result: IntLiteral
#     alias n = abs(value)

#     @parameter
#     if n == 0: result = 0
#     elif n == 1: result = 1
#     elif n == 2: result = 2
#     elif n == 3: result = 3
#     elif n == 4: result = 4
#     elif n == 5: result = 5
#     elif n == 6: result = 6
#     else:
#         print("oh no")
#         return 0

#     @parameter
#     if value < 0: return -result
#     else: return result


# # +------( other and norms )------+ #
# # evenexp
# # oddexp
# # parts
# # pnorm
