# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +------ SIMD Newtons Method ------+ #
#
fn newtons_method[
    type: DType,
    size: Int, //,
    f: fn (value: SIMD) -> __type_of(value),
    df: fn (value: SIMD) -> __type_of(value),
    iterations: Int = 8,
    tolerance: FloatLiteral = NAN,
    epsilon: FloatLiteral = NAN,
](x0: SIMD[type, size], y_offset: SIMD[type, size] = 0) -> SIMD[type, size]:
    """
    Implements newtons method for solving trancendental equations.\n
    Converges on the roots of the input function `f` using it's derivative `fp`.\n
    If `tolerance` and `epsilon` are left undefined, only iterations will be used, and may return non-convergent results.

    Constraints:
        Parameter `type` must be floating-point.

    Parameters:
        type: The DType of values used in calculation.
        size: The SIMD vector size of the values.
        f: The function to find the solutions to.
        df: The first derivative of f (not calculated automatically).
        iterations: The number of iterations to perform.
        tolerance: If provided, results within the tolerance will be considered solved.
        epsilon: If provided, the calculation will return `nan` for values that explode.

    Args:
        x0: The initial guess of the solution. Determines which solution is found, and how fast it converges.
        y_offset: A vertical offset applied to the input function `f`. Use for solving the inverse of `f`, for values other than 0.

    Returns:
        The converged value, or `nan` if no solution was found.
    """

    constrained[
        type.is_floating_point(), "`type` parameter must be a floating-point"
    ]()
    alias _nan: SIMD[type, size] = nan[type]()

    var completed: SIMD[DType.bool, size] = False
    var x1: SIMD[type, size] = x0

    @parameter
    for _ in range(iterations):
        var yp = df(x1)

        @parameter
        if not isnan(epsilon):
            var exploded = abs(yp) <= epsilon
            completed |= exploded
            x1 = select(exploded, _nan, x1)

        var x2 = x1 - (f(x1) - y_offset) / yp

        @parameter
        if not isnan(tolerance):
            completed |= abs(x2 - x1) <= tolerance

        @parameter
        if not isnan(tolerance) or not isnan(epsilon):
            if completed.reduce_and():
                return x1
            x1 = select(completed, x1, x2)
        else:
            x1 = x2

    @parameter
    if not isnan(tolerance) or not isnan(epsilon):
        return select(completed, x1, _nan)
    return x1


# +------ Float Literal Newtons Method ------+ #
#
fn newtons_method[
    f: fn (FloatLiteral) capturing -> FloatLiteral,
    df: fn (FloatLiteral) capturing -> FloatLiteral,
    iterations: Int = 8,
    tolerance: FloatLiteral = NAN,
    epsilon: FloatLiteral = NAN,
](x0: FloatLiteral, y_offset: FloatLiteral = 0) -> FloatLiteral:
    """
    Implements newtons method for solving trancendental equations.\n
    Converges on the roots of the input function `f` using it's derivative `fp`.\n
    If `tolerance` and `epsilon` are left undefined, only iterations will be used, and may return non-convergent results.

    Parameters:
        f: The function to find the solutions to.
        df: The first derivative of f (not calculated automatically).
        iterations: The number of iterations to perform.
        tolerance: If provided, results within the tolerance will be considered solved.
        epsilon: If provided, the calculation will return `nan` for values that explode.

    Args:
        x0: The initial guess of the solution. Determines which solution is found, and how fast it converges.
        y_offset: A vertical offset applied to the input function `f`. Use for solving the inverse of `f`, for values other than 0.

    Returns:
        The converged value, or `nan` if no solution was found.
    """

    var x1: FloatLiteral = x0

    @parameter
    for _ in range(iterations):
        var yp: FloatLiteral = df(x1)

        @parameter
        if not isnan(epsilon):
            if abs(yp) <= epsilon:
                return NAN

        var x2: FloatLiteral = x1 - (f(x1) - y_offset) / yp

        @parameter
        if not isnan(tolerance):
            if abs(x2 - x1) <= tolerance:
                return x2

        x1 = x2

    @parameter
    if not isnan(tolerance) or not isnan(epsilon):
        return NAN
    return x1


# +------ HybridSIMD Newtons Method ------+ #
#
fn newtons_method[
    type: DType,
    size: Int,
    square: FloatLiteral, //,
    f: fn (value: HybridSIMD) -> __type_of(value),
    df: fn (value: HybridSIMD) -> __type_of(value),
    iterations: Int = 8,
    tolerance: FloatLiteral = NAN,
    epsilon: FloatLiteral = NAN,
](
    x0: HybridSIMD[type, size, square],
    y_offset: HybridSIMD[type, size, square] = 0,
) -> HybridSIMD[type, size, square]:
    """
    Implements newtons method for solving trancendental equations.\n
    Converges on the roots of the input function `f` using it's derivative `fp`.\n
    If `tolerance` and `epsilon` are left undefined, only iterations will be used, and may return non-convergent results.

    Constraints:
        Parameter `type` must be floating-point.

    Parameters:
        type: The DType of values used in calculation.
        size: The SIMD vector size of the values.
        square: The value of the antiox squared.
        f: The function to find the solutions to.
        df: The first derivative of f (not calculated automatically).
        iterations: The number of iterations to perform.
        tolerance: If provided, results within the tolerance will be considered solved.
        epsilon: If provided, the calculation will return `nan` for values that explode.

    Args:
        x0: The initial guess of the solution. Determines which solution is found, and how fast it converges.
        y_offset: A vertical offset applied to the input function `f`. Use for solving the inverse of `f`, for values other than 0.

    Returns:
        The converged value, or `nan` if no solution was found.
    """

    constrained[
        type.is_floating_point(), "`type` parameter must be a floating-point"
    ]()
    alias _nan: SIMD[type, size] = nan[type]()

    var completed: SIMD[DType.bool, size] = False
    var x1: HybridSIMD[type, size, square] = x0

    @parameter
    for _ in range(iterations):
        var yp = df(x1)

        @parameter
        if not isnan(epsilon):
            var exploded = l1norm(yp) <= epsilon
            completed |= exploded
            x1 = select(exploded, _nan, x1)

        var x2 = x1 - (f(x1) - y_offset) / yp

        @parameter
        if not isnan(tolerance):
            completed |= l1norm(x2 - x1) <= tolerance

        @parameter
        if not isnan(tolerance) or not isnan(epsilon):
            if completed.reduce_and():
                return x1
            x1 = select(completed, x1, x2)
        else:
            x1 = x2

    @parameter
    if not isnan(tolerance) or not isnan(epsilon):
        return select(completed, x1, _nan)
    return x1
