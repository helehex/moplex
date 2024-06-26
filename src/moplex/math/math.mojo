"""
Implements the moplex math module.

Defines generalized complex math functions.
"""

from collections import Optional
from .solver import newtons_method



#------------ Select ------------#
#---
#--- SIMD conditional select
#---
from math import select as _select

@always_inline # mock std
fn select[type: DType, size: Int](cond: SIMD[DType.bool,size], true_case: SIMD[type,size], false_case: SIMD[type,size]) -> SIMD[type,size]:
    """From stdlib."""
    return _select(cond, true_case, false_case)

@always_inline # Hybrid _ Scalar
fn select[type: DType, size: Int, square: FloatLiteral](cond: SIMD[DType.bool,size], true_case: HybridSIMD[type,size,square], false_case: SIMD[type,size]) -> HybridSIMD[type,size,square]:
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
    return HybridSIMD[type,size,square](select(cond, true_case.s, false_case), select(cond, true_case.a, 0))

@always_inline # Scalar _ Hybrid
fn select[type: DType, size: Int, square: FloatLiteral](cond: SIMD[DType.bool,size], true_case: SIMD[type,size], false_case: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
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
    return HybridSIMD[type,size,square](select(cond, true_case, false_case.s), select(cond, 0, false_case.a))

@always_inline # Hybrid _ Hybrid
fn select[type: DType, size: Int, square: FloatLiteral](cond: SIMD[DType.bool,size], true_case: HybridSIMD[type,size,square], false_case: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
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
    return HybridSIMD[type,size,square](select(cond, true_case.s, false_case.s), select(cond, true_case.a, false_case.a))




#------( Square Root )------#
#
from math import sqrt as _sqrt

@always_inline
fn sqrt(value: IntLiteral) -> IntLiteral:
    """Returns the square root of the input IntLiteral. This may change."""
    if value <= 1: return value
    var a: IntLiteral = value // 2
    var b: IntLiteral = (a + value//a) // 2
    while b < a:
        a = b
        b = (a + value//a) // 2
    return a

@always_inline
fn sqrt[type: DType, size: Int, value: SIMD[type,size]]() -> SIMD[type,size]:
    """Returns the square root of the input simd vector."""
    @parameter
    if type.is_floating_point(): return select(value == 0, 0, 1/rsqrt[type,size,value]())

    var negative = (value <= 0)
    var finished = (negative) | (value == 1)
    var a = select(negative, -1, (value + 1)/2)
    while not finished:
        var b = (a + value/a) / 2
        finished |= b >= a
        a = select(finished, a, b)
    return select(negative, 0, a)

@always_inline
fn sqrt(value: FloatLiteral) -> FloatLiteral:
    """Returns the square root of the input FloatLiteral. This may change."""
    return 1/rsqrt(value)

@always_inline # mock std
fn sqrt(value: Int) -> Int:
    """
    Performs square root on an integer.

    Args:
        value: The integer value to perform square root on.

    Returns:
        The square root of x.
    """
    return _sqrt(value)

@always_inline # mock std
fn sqrt(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Performs elementwise square root on the elements of a SIMD vector.

    Args:
        value: SIMD vector to perform square root on.

    Returns:
        The elementwise square root of x.
    """
    return _sqrt(value)

@always_inline
fn sqrt[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    return pow(value, 0.5)




#------( Inverse Square Root )------#
#
from math import rsqrt as _rsqrt

@always_inline
fn rsqrt[type: DType, size: Int, value: SIMD[type,size]]() -> SIMD[type,size]:
    """Returns the reciprocal square root of the input simd vector."""
    @parameter
    if type.is_integral(): return 0

    var negative = value <= 0
    var finished = negative | (value == 1)
    var a = select[type,size](negative, nan[type](), 2/(value + 1))
    while not finished:
        var b = (a/2) * (3 - value*a*a)
        finished |= b <= a
        a = select(finished, a, b)
    return a

@always_inline
fn rsqrt(value: FloatLiteral) -> FloatLiteral:
    """Returns the reciprocal square root of the input FloatLiteral. This may change."""
    @parameter
    fn f(value: FloatLiteral) -> FloatLiteral: return 1/(value*value)

    @parameter
    fn df(value: FloatLiteral) -> FloatLiteral: return -2/(value*value*value)
    return newtons_method[f, df, 8, 1e-8](2/(value + 1), value)

@always_inline # mock std
fn rsqrt(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Performs elementwise reciprocal square root on the elements of a SIMD vector.

    Args:
        value: SIMD vector to perform reciprocal square root on.

    Returns:
        The elementwise reciprocal square root of x.
    """
    return _rsqrt(value)

@always_inline
fn rsqrt[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    return pow(value, -0.5)



#------ Natural Exponential ------#
#
from math import exp as _exp

# @always_inline
# fn exp(value: FloatLiteral) -> FloatLiteral:
#     """Returns e^value for the input FloatLiteral. This may change."""
#     return exp(Float64(value)).value

@always_inline # mock std
fn exp(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Calculates elementwise e^{X_i}, where X_i is an element in the input SIMD vector at position i.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Xi where Xi is an element in the input SIMD vector.
    """
    return _exp(value)

# change to use antiox type?
@always_inline
fn expa[type: DType, size: Int, square: FloatLiteral](value: SIMD[type, size]) -> HybridSIMD[type, size, square]:
    """
    Antiox exponential.

    Calculates elementwise e^{Antiox(X_i)}, where X_i is an element in the input SIMD vector at position i.

    Parameters:
        type: The dtype of the input and output SIMD vector.
        size: The width of the input and output SIMD vector.
        square: The antiox squared.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Antiox(Xi) where Xi is an element in the input SIMD vector.
    """
    @parameter
    if square == -1: return HybridSIMD[type, size, square](cos(value), sin(value))
    elif square == 0: return HybridSIMD[type, size, square](1, value)
    elif square == 1: return HybridSIMD[type, size, square](cosh(value), sinh(value))

    var conversion = sqrt(abs[type,1,square]())
    var result = expa[type,size,sign(square)](value*conversion)
    return HybridSIMD[type, size, square](result.s, result.a/conversion)

@always_inline
fn exp[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    """
    Hybrid exponential.

    Calculates elementwise e^Hybrid_i, where Hybrid_i is an element in the input SIMD vector at position i.

    Parameters:
        type: The dtype of the input and output SIMD vector.
        size: The width of the input and output SIMD vector.
        square: The hybrid antiox squared.

    Args:
        value: The input SIMD vector.

    Returns:
        A SIMD vector containing e raised to the power Hybrid_i, where Hybrid_i is an element in the input SIMD vector.
    """
    return exp(value.s) * expa[type, size, square](value.a)




#------ Power ------#
#
from math import pow as _pow

# @always_inline
# fn pow(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
#     """Mocks stdlib."""
#     return pow(Float64(a), Float64(b)).value

# @always_inline
# fn pow[square: FloatLiteral](a: HybridFloatLiteral[square], b: FloatLiteral) -> HybridFloatLiteral[square]:
#     """FloatLiteral version of hybrid pow."""
#     var result = pow[DType.float64,1,square](a, b)
#     return HybridFloatLiteral[square](result.s.value, result.a.value)

# @always_inline
# fn pow[square: FloatLiteral](a: FloatLiteral, b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
#     """FloatLiteral version of hybrid pow."""
#     var result = pow[DType.float64,1,square](a, b)
#     return HybridFloatLiteral[square](result.s.value, result.a.value)

# @always_inline
# fn pow[square: FloatLiteral](a: HybridFloatLiteral[square], b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
#     """FloatLiteral version of hybrid pow."""
#     var result = pow[DType.float64,1,square](a, b)
#     return HybridFloatLiteral[square](result.s.value, result.a.value)

@always_inline
fn pow(a: SIMD, b: Int) -> SIMD[a.type, a.size]:
    """Mocks stdlib."""
    return _pow(a, b)

@always_inline
fn pow(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Mocks stdlib."""
    return _pow(a, b)

@always_inline
fn pow[type: DType, size: Int, square: FloatLiteral](a: HybridSIMD[type,size,square], b: Int) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a hybrid type raised to another hybrid type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    return pow(a.measure[True](),b)*expa[type,size,square](a.argument()*b)

@always_inline
fn pow[type: DType, size: Int, square: FloatLiteral](a: HybridSIMD[type,size,square], b: SIMD[type,size]) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a HybridSIMD type raised to a SIMD type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    @parameter
    if square == 0: return pow(a.s, b-1) * HybridSIMD[type,size,square](a.s, a.a*b)
    return exp(b*log(a))

@always_inline
fn pow[type: DType, size: Int, square: FloatLiteral](a: SIMD[type,size], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a SIMD type raised to a HybridSIMD type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    return exp(b*log(a))

@always_inline
fn pow[type: DType, size: Int, square: FloatLiteral, branch: Int = 0](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Computes elementwise power of a HybridSIMD type raised to another HybridSIMD type.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.
        branch: The multivalue branch to propagate.

    Args:
        a: Base of the power operation.
        b: Exponent of the power operation.

    Returns:
        A HybidSIMD vector containing elementwise lhs raised to the power of rhs.
    """
    @parameter
    if square == 0: return pow(a.s, b.s-1) * HybridSIMD[type,size,square](a.s, b.a*a.s*log(a.s) + a.a*b.s)
    return exp(b*log[branch = branch](a))




#------ Logarithm ------#
#
from math import log as _log

# @always_inline # mock std
# fn log(value: FloatLiteral) -> FloatLiteral:
#     """Returns the logarithm of the input FloatLiteral. May change."""
#     return log(Float64(value)).value

@always_inline # mock
fn log(value: SIMD) -> SIMD[value.type, value.size]:
    """
    Performs elementwise natural log (base E) of a SIMD vector.

    Args:
        value: Vector to perform logarithm operation on.

    Returns:
        Vector containing result of performing natural log base E on x.
    """
    return _log(value)

@always_inline
fn log[type: DType, size: Int, square: FloatLiteral, branch: Int = 0](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Performs elementwise natural log (base E) of a HybridSIMD vector.

    Args:
        value: Vector to perform logarithm operation on.

    Returns:
        Vector containing result of performing natural log base E on x.
    """
    @parameter
    if square == 0: return HybridSIMD[type,size,square](log(value.measure()), value.argument[branch]())
    return HybridSIMD[type,size,square](value.lmeasure[True](), value.argument[branch]())




#------( Lambert W )------#
#
@always_inline
fn _xex[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    return value*exp(value)

@always_inline
fn _dxex[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    var ex = exp(value)
    return ex + value*ex

@always_inline
fn lw[type: DType, size: Int, square: FloatLiteral, branch: Int = 0](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """
    Computes the elementwise Lambert W function of a HybridSIMD vector.

    The Lamber W function is defined as: `lw(x*(e**x)) = x` for a variable x.

    Parameters:
        type: The dtype of the HybridSIMD vectors.
        size: The width of the input and output SIMD vectors.
        square: The antiox squared of the input hybrid numbers.
        branch: The multivalue branch to propagate.

    Args:
        value: HybridSIMD vector to perform lambert w on.

    Returns:
        HybridSIMD Vector containing the results.
    """
    var guess: HybridSIMD[type,size,square]

    @parameter # work out more branch selection
    if branch == -1: guess = log(-value)*2
    else: guess = log[branch=branch](value + 1)

    return newtons_method[type, size, square, _xex[type,size,square], _dxex[type,size,square], 8, 1e-8](guess, value)



#------( Sine )------#
#
from math import sin as _sin

# @always_inline
# fn sin(value: FloatLiteral) -> FloatLiteral:
#     """Computes sine of the input."""
#     return sin(Float64(value)).value

@always_inline
fn sin(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes sine of the input."""
    return _sin(value)

@always_inline
fn sin[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """Computes sine of the input."""
    @parameter
    if square == -1: return HybridSIMD[type,size,square](sin(value.s) * cosh(value.a), cos(value.s) * sinh(value.a))
    elif square == 0: return HybridSIMD[type,size,square](sin(value.s), cos(value.s) * value.a)
    elif square == 1: return HybridSIMD[type,size,square](sin(value.s) * cos(value.a), cos(value.s) * sin(value.a))

    return sin(value.to_unital()).cast[target_square=square]()




#------ Cosine ------#
#
from math import cos as _cos

# @always_inline
# fn cos(value: FloatLiteral) -> FloatLiteral:
#     """Computes cosine of the input."""
#     return cos(Float64(value)).value

@always_inline
fn cos(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes cosine of the input."""
    return _cos(value)

@always_inline
fn cos[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """Computes cosine of the input."""
    @parameter
    if square == -1: return HybridSIMD[type,size,square](cos(value.s) * cosh(value.a), -sin(value.s) * sinh(value.a))
    elif square == 0: return HybridSIMD[type,size,square](cos(value.s), -sin(value.s) * value.a)
    elif square == 1: return HybridSIMD[type,size,square](cos(value.s) * cos(value.a), -sin(value.s) * sin(value.a))

    return cos(value.to_unital()).cast[target_square=square]()




#------( Tangent )------#
#
from math import tan as _tan

# @always_inline
# fn tan(value: FloatLiteral) -> FloatLiteral:
#     """Computes tangent of the input."""
#     return tan(Float64(value)).value

@always_inline
fn tan(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes tangent of the input."""
    return _tan(value)

@always_inline
fn tan[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """Computes tangent of the input."""
    # check if 2* is optimized
    @parameter
    if square == -1: return HybridSIMD[type,size,square](sin(2*value.s), sinh(2*value.a)) / (cos(2*value.s) + cosh(2*value.a))
    elif square == 0: return HybridSIMD[type,size,square](tan(value.s), (sec(value.s)**2) * value.a)
    elif square == 1: return HybridSIMD[type,size,square](sin(2*value.s), sin(2*value.a)) / (cos(2*value.s) + cos(2*value.a))

    return tan(value.to_unital()).cast[target_square=square]()




#------( Cotangent )------#
#
# @always_inline
# fn cot(value: FloatLiteral) -> FloatLiteral:
#     """Computes cotangent of the input."""
#     return tan(hfpi - value)

@always_inline
fn cot(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes cotangent of the input."""
    return tan(hfpi - value)

@always_inline
fn cot[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """Computes cotangent of the input."""
    # check if 1/tan is optimized
    @parameter
    if square == -1: return (cos(2*value.s) + cosh(2*value.a)) / HybridSIMD[type,size,square](sin(2*value.s), sinh(2*value.a))
    elif square == 0: return HybridSIMD[type,size,square](cot(value.s), -(csc(value.s)**2) * value.a)
    elif square == 1: return (cos(2*value.s) + cos(2*value.a)) / HybridSIMD[type,size,square](sin(2*value.s), sin(2*value.a))

    return cot(value.to_unital()).cast[target_square=square]()




#------ Secant ------#
#
# @always_inline
# fn sec(value: FloatLiteral) -> FloatLiteral:
#     """Computes secant of the input."""
#     return 1/cos(value)

@always_inline
fn sec(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes secant of the input."""
    return 1/cos(value)

@always_inline
fn sec[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """Computes secant of the input."""
    return 1/cos(value)




#------ Cosecant ------#
#
# @always_inline
# fn csc(value: FloatLiteral) -> FloatLiteral:
#     """Computes cosecant of the input."""
#     return 1/sin(value)

@always_inline
fn csc(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes cosecant of the input."""
    return 1/sin(value)

@always_inline
fn csc[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]:
    """Computes cosecant of the input."""
    return 1/sin(value)




#------ Hyperbolic Sine ------#
#
from math import sinh as _sinh

# @always_inline
# fn sinh(value: FloatLiteral) -> FloatLiteral:
#     """Computes hyperbolic sine of the input."""
#     return sinh(Float64(value)).value

@always_inline
fn sinh(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes hyperbolic sine of the input."""
    return _sinh(value)




#------ Hyperbolic Cosine ------#
#
from math import cosh as _cosh

# @always_inline
# fn cosh(value: FloatLiteral) -> FloatLiteral:
#     """Computes hyperbolic cosine of the input."""
#     return cosh(Float64(value)).value

@always_inline
fn cosh(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes hyperbolic cosine of the input."""
    return _cosh(value)




#------( Hyperbolic Tangent )------#
#
from math import tanh as _tanh

# @always_inline
# fn tanh(value: FloatLiteral) -> FloatLiteral:
#     """Computes hyperbolic tangent of the input."""
#     return tanh(Float64(value)).value

@always_inline
fn tanh(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes hyperbolic tangent of the input."""
    return _tanh(value)




#------( Hyperbolic Cotangent )------#
#
# @always_inline
# fn coth(value: FloatLiteral) -> FloatLiteral:
#     """Computes hyperbolic cotangent of the input."""
#     return 1/tanh(value)

@always_inline
fn coth(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes hyperbolic cotangent of the input."""
    return 1/tanh(value)




#------( Hyperbolic Secant )------#
#
# @always_inline
# fn sech(value: FloatLiteral) -> FloatLiteral:
#     """Computes hyperbolic secant of the input."""
#     return 1/cosh(value)

@always_inline
fn sech(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes hyperbolic secant of the input."""
    return 1/cosh(value)




#------( Hyperbolic Cosecant )------#
#
# @always_inline
# fn csch(value: FloatLiteral) -> FloatLiteral:
#     """Computes hyperbolic cosecant of the input."""
#     return 1/sinh(value)

@always_inline
fn csch(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes hyperbolic cosecant of the input."""
    return 1/sinh(value)




#------( Arcsine )------#
#
from math import asin as _asin

# @always_inline
# fn asin(value: FloatLiteral) -> FloatLiteral:
#     """Computes the arcsine of the input."""
#     return _asin(Float64(value)).value

@always_inline
fn asin(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes the arcsine of the input."""
    return _asin(value)




#------( Arccosine )------#
#
from math import acos as _acos

# @always_inline
# fn acos(value: FloatLiteral) -> FloatLiteral:
#     """Computes the arccosine of the input."""
#     return _acos(Float64(value)).value

@always_inline
fn acos(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes the arccosine of the input."""
    return _acos(value)




#------( Arctangent )------#
#
from math import atan as _atan
from math import atan2 as _atan2

# @always_inline
# fn atan(value: FloatLiteral) -> FloatLiteral:
#     """Computes arctangent of the input."""
#     return _atan(Float64(value)).value

@always_inline
fn atan(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes arctangent of the input."""
    return _atan(value)

# @always_inline
# fn atan2(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
#     """Computes quadrant adjusted arctangent of the inputs."""
#     return atan2(Float64(a), Float64(b)).value

@always_inline
fn atan2(a: Int, b: Int) -> Float64:
    """Computes quadrant adjusted arctangent of the inputs."""
    return _atan2[DType.float64, 1](a,b)

@always_inline
fn atan2[type: DType, size: Int](a: SIMD[type, size], b: SIMD[type, size]) -> SIMD[type, size]:
    """Computes quadrant adjusted arctangent of the inputs."""
    return _atan2(a,b)




#------( Hyperbolic Arcsine )------#
#
from math import asinh as _asinh

# @always_inline
# fn asinh(value: FloatLiteral) -> FloatLiteral:
#     """Computes the hyperbolic arcsine of the input."""
#     return _asinh(Float64(value)).value

@always_inline
fn asinh(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes the hyperbolic arcsine of the input."""
    return _asinh(value)




#------( Hyperbolic Arccosine )------#
#
from math import acosh as _acosh

# @always_inline
# fn acosh(value: FloatLiteral) -> FloatLiteral:
#     """Computes the hyperbolic arccosine of the input."""
#     return _acosh(Float64(value)).value

@always_inline
fn acosh(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes the hyperbolic arccosine of the input."""
    return _acosh(value)




#------( Hyperbolic Arctangent )------#
#
from math import atanh as _atanh

# @always_inline
# fn atanh(value: FloatLiteral) -> FloatLiteral:
#     """Computes hyperbolic arctangent of the input."""
#     return _atanh(Float64(value)).value

@always_inline
fn atanh(value: SIMD) -> SIMD[value.type, value.size]:
    """Computes hyperbolic arctangent of the input."""
    return _atanh(value)




#------( Absolute Value)------#
#
from math import abs as _abs

@always_inline
fn abs(value: IntLiteral) -> IntLiteral:
    """Returns the positive definite absolute value of the input."""
    if value > 0: return value
    return -value

@always_inline
fn abs(value: FloatLiteral) -> FloatLiteral:
    """Returns the positive definite absolute value of the input."""
    if value > 0: return value
    return -value

@always_inline
fn abs(value: Int) -> Int:
    """Returns the positive definite absolute value of the input."""
    return _abs(value)

@always_inline
fn abs[type: DType, size: Int, value: SIMD[type,size]]() -> SIMD[type, size]:
    """Returns the positive definite absolute value of the input."""
    @parameter
    if value > 0: return value
    else: return -value

@always_inline
fn abs(value: SIMD) -> SIMD[value.type, value.size]:
    """Returns the positive definite absolute value of the input."""
    return _abs(value)




#------( Sign )------#
#
from math import copysign as _copysign

@always_inline
fn sign(value: IntLiteral) -> IntLiteral:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

@always_inline
fn sign(value: FloatLiteral) -> FloatLiteral:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

@always_inline
fn sign(value: Int) -> Int:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

@always_inline
fn sign[type: DType, size: Int, value: SIMD[type, size]]() -> SIMD[type, size]:
    """Returns the sign {+,0,-} of the input."""
    @parameter
    if value > 0: return 1
    elif value < 0: return -1
    else: return 0

@always_inline
fn sign(value: SIMD) -> SIMD[value.type, value.size]:
    """Returns the sign {+,0,-} of the input."""
    return compare(value, 0)

# @always_inline
# fn sign[type: DType, size: Int](value: SIMD[type, size]) -> SIMD[type, size]:
#     return compare(value, 0)

# @always_inline
# fn sign(value: SIMD) -> SIMD[value.type, value.size]:
#     return _copysign(1, value)

# @always_inline
# fn sign[type: DType](value: SIMD[type,1]) -> SIMD[type, 1]:
#     if value > 0: return 1
#     elif value < 0: return -1
#     return 0




#------( Compare )------#
#
@always_inline
fn compare(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    if a > b: return 1
    elif a < b: return -1
    return 0

@always_inline
fn compare(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    if a > b: return 1
    elif a < b: return -1
    return 0

@always_inline
fn compare(a: Int, b: Int) -> Int:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (SIMD[DType.index, 1](a > b) - SIMD[DType.index, 1](a < b)).value

@always_inline
fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (a > b).cast[type]() - (a < b).cast[type]()

@always_inline
fn compare(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Compares the two inputs, and returns -1 if a < b, 0 if a = b, and 1 if a > b."""
    return (a > b).cast[a.type]() - (a < b).cast[a.type]()

# @always_inline
# fn compare[type: DType, size: Int, a: SIMD[type, size], b: SIMD[type, size]]() -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))

# @always_inline
# fn compare[type: DType, size: Int](a: SIMD[type, size], b: SIMD[type, size]) -> SIMD[type, size]:
#     return (a > b).select(1,(a < b).select[type](-1, 0))




#------( Unital Factor )------#
#
@always_inline
fn ufac(square: FloatLiteral) -> FloatLiteral:
    if square == sign(square): return 1
    else: return sqrt(abs(square))




#------( Contrast )------#
#
@always_inline
fn contrast[square: FloatLiteral](value: FloatLiteral) -> FloatLiteral:
    @parameter
    if square == 0: return abs(value)
    else: return value*value

@always_inline
fn contrast[square: FloatLiteral](value: IntLiteral) -> IntLiteral:
    @parameter
    if square == 0: return abs(value)
    else: return value*value

@always_inline
fn contrast[square: FloatLiteral](value: Int) -> Int:
    @parameter
    if square == 0: return abs(value)
    else: return value*value

@always_inline
fn contrast[square: FloatLiteral](value: SIMD) -> SIMD[value.type, value.size]:
    @parameter
    if square == 0: return abs(value)
    else: return value*value




#------( Min )------#
#
from math import min as _min

@always_inline
fn min(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    """Returns the value which is closest to negative infinity."""
    if a <= b: return a
    return b

@always_inline
fn min(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Returns the value which is closest to negative infinity."""
    # check nan
    if a <= b: return a
    return b

@always_inline
fn min(a: Int, b: Int) -> Int:
    """Return the value which is closest to negative infinity."""
    return _min(a, b)

@always_inline
fn min(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Return the value which is closest to negative infinity."""
    return _min(a, b)

@always_inline
fn min[square: FloatLiteral](a: HybridInt[square], b: HybridInt[square]) -> HybridInt[square]:
    """Return the value which is closest to negative infinity."""
    return a if a < b else b

@always_inline
fn min[type: DType, size: Int, square: FloatLiteral](a: HybridSIMD[type, size, square], b: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    """Return the value which is closest to negative infinity."""
    var cond = (a < b) | (isnan_hybrid(a))
    return select(cond, a, b)

@always_inline
fn min[square: FloatLiteral](a: HybridIntLiteral[square], b: HybridIntLiteral[square]) -> HybridIntLiteral[square]:
    if a < b: return a
    return b

@always_inline
fn min[square: FloatLiteral](a: HybridFloatLiteral[square], b: HybridFloatLiteral[square]) -> HybridFloatLiteral[square]:
    if a < b: return a
    return b




#------( Max )------#
#
from math import max as _max

@always_inline
fn max(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    """Return the value which is closest to positive infinity."""
    if a >= b: return a
    return b

@always_inline
fn max(a: FloatLiteral, b: FloatLiteral) -> FloatLiteral:
    """Return the value which is closest to positive infinity."""
    # check nan
    if a >= b: return a
    return b

@always_inline
fn max(a: Int, b: Int) -> Int:
    """Return the value which is closest to positive infinity."""
    return _max(a, b)

@always_inline
fn max(a: SIMD, b: SIMD[a.type, a.size]) -> SIMD[a.type, a.size]:
    """Return the value which is closest to positive infinity."""
    return _max(a, b)

@always_inline
fn max[square: FloatLiteral](a: HybridInt[square], b: HybridInt[square]) -> HybridInt[square]:
    """Return the value which is closest to positive infinity."""
    return a if a > b else b

@always_inline
fn max[type: DType, size: Int, square: FloatLiteral](a: HybridSIMD[type, size, square], b: HybridSIMD[type, size, square]) -> HybridSIMD[type, size, square]:
    """Return the value which is closest to positive infinity."""
    var cond = (a > b) | (isnan_hybrid(a))
    return select(cond, a, b)




#------ L1Norm ------#
#
@always_inline
fn l1norm[type: DType, size: Int, square: FloatLiteral](value: HybridSIMD[type,size,square]) -> SIMD[type,size]:
    return abs(value.s) + abs(value.a)

@always_inline
fn l1norm(value: MultiplexSIMD) -> SIMD[value.type,value.size]:
    return abs(value.s) + abs(value.i) + abs(value.o) + abs(value.x)




# @always_inline
# fn contrast()






# dont look, Int to IntLiteral workaround

@always_inline
fn to_int_literal[value: Int]() -> IntLiteral:
    var result: IntLiteral
    alias n = abs(value)

    @parameter
    if n == 0: result = 0
    elif n == 1: result = 1
    elif n == 2: result = 2
    elif n == 3: result = 3
    elif n == 4: result = 4
    elif n == 5: result = 5
    elif n == 6: result = 6
    else:
        print("oh no")
        return 0

    @parameter
    if value < 0: return -result
    else: return result




#------( other and norms )------#
# evenexp
# oddexp
# parts
# pnorm








