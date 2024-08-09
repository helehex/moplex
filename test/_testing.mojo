# ! helper functions for testing

from collections import Optional
from testing import assert_almost_equal as _assert_almost_equal
from testing import assert_equal as _assert_equal
from testing.testing import (
    Testable,
    isclose,
    _SourceLocation,
    _assert_error,
    __call_location,
    _assert_cmp_error,
)
from moplex import HybridSIMD, symbol, HybridFloatLiteral


@always_inline
fn assert_almost_equal[
    type: DType, size: Int
](
    lhs: SIMD[type, size],
    rhs: SIMD[type, size],
    msg: String = "",
    *,
    atol: Scalar[type] = 1e-08,
    rtol: Scalar[type] = 1e-05,
    equal_nan: Bool = False,
    location: Optional[_SourceLocation] = None,
) raises:
    _assert_almost_equal(
        lhs,
        rhs,
        msg,
        atol=atol,
        rtol=rtol,
        equal_nan=equal_nan,
        location=location.or_else(__call_location()),
    )


@always_inline
fn assert_almost_equal[
    type: DType, size: Int, square: FloatLiteral
](
    lhs: HybridSIMD[type, size, square],
    rhs: HybridSIMD[type, size, square],
    msg: String = "",
    *,
    atol: Scalar[type] = 1e-08,
    rtol: Scalar[type] = 1e-05,
    equal_nan: Bool = False,
    location: Optional[_SourceLocation] = None,
) raises:
    constrained[
        type is DType.bool or type.is_integral() or type.is_floating_point(),
        "type must be boolean, integral, or floating-point",
    ]()

    var real_almost_equal = isclose(
        lhs.re, rhs.re, atol=atol, rtol=rtol, equal_nan=equal_nan
    )

    var anti_almost_equal = isclose(
        lhs.im, rhs.im, atol=atol, rtol=rtol, equal_nan=equal_nan
    )

    if not all(real_almost_equal) or not all(anti_almost_equal):
        var err = str(lhs) + " is not close to " + str(rhs)

        @parameter
        if type.is_integral() or type.is_floating_point():
            err += (
                " with a diff of "
                + str(abs(lhs.re - rhs.re))
                + " + "
                + str(abs(lhs.im - rhs.im))
                + symbol[square]()
            )

        if msg:
            err += " (" + msg + ")"

        raise _assert_error(err, location.or_else(__call_location()))



@always_inline
fn assert_equal_(
    lhs: HybridFloatLiteral,
    rhs: __type_of(lhs),
    msg: String = "",
    *,
    location: Optional[_SourceLocation] = None,
) raises:
    """Asserts that the input values are equal. If it is not then an Error
    is raised.

    Parameters:
        T: A Testable type.

    Args:
        lhs: The lhs of the equality.
        rhs: The rhs of the equality.
        msg: The message to be printed if the assertion fails.
        location: The location of the error (default to the `__call_location`).

    Raises:
        An Error with the provided message if assert fails and `None` otherwise.
    """
    if lhs != rhs:
        raise _assert_cmp_error["`left == right` comparison"](
            str(lhs), str(rhs), msg=msg, loc=location.or_else(__call_location())
        )


@always_inline
fn assert_not_equal_(
    lhs: HybridFloatLiteral,
    rhs: __type_of(lhs),
    msg: String = "",
    *,
    location: Optional[_SourceLocation] = None,
) raises:
    """Asserts that the input values are not equal. If it is not then an
    Error is raised.

    Parameters:
        T: A Testable type.

    Args:
        lhs: The lhs of the inequality.
        rhs: The rhs of the inequality.
        msg: The message to be printed if the assertion fails.
        location: The location of the error (default to the `__call_location`).

    Raises:
        An Error with the provided message if assert fails and `None` otherwise.
    """
    if lhs == rhs:
        raise _assert_cmp_error["`left != right` comparison"](
            str(lhs), str(rhs), msg=msg, loc=location.or_else(__call_location())
        )



# @always_inline
# fn assert_equal[
#     T: Testable
# ](
#     lhs: T,
#     rhs: T,
#     msg: String = "",
#     *,
#     location: Optional[_SourceLocation] = None,
# ) raises:
#     _assert_equal(lhs, rhs, msg, location=location.or_else(__call_location()))


# @always_inline
# fn assert_equal(
#     lhs: String,
#     rhs: String,
#     msg: String = "",
#     *,
#     location: Optional[_SourceLocation] = None,
# ) raises:
#     _assert_equal(lhs, rhs, msg, location=location.or_else(__call_location()))


# @always_inline
# fn assert_equal[
#     type: DType, size: Int
# ](
#     lhs: SIMD[type, size],
#     rhs: SIMD[type, size],
#     msg: String = "",
#     *,
#     location: Optional[_SourceLocation] = None,
# ) raises:
#     _assert_equal(lhs, rhs, msg, location=location.or_else(__call_location()))


# @always_inline
# fn assert_equal[
#     type: DType, size: Int, square: FloatLiteral
# ](
#     lhs: HybridSIMD[type, size, square],
#     rhs: HybridSIMD[type, size, square],
#     msg: String = "",
#     *,
#     location: Optional[_SourceLocation] = None,
# ) raises:
#     if any(lhs != rhs):
#         raise _assert_cmp_error["`left == right` comparison"](
#             str(lhs), str(rhs), msg=msg, loc=location.or_else(__call_location())
#         )
