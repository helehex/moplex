# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Implements the moplex io module.

Defines io functions for generalized complex numbers.
"""


@always_inline("nodebug")
fn antiox(symbol: StringLiteral) -> IntLiteral:
    if symbol == "i":
        return -1
    elif symbol == "o":
        return 0
    elif symbol == "x":
        return 1
    debug_assert(False, "invalid antiox")
    return 0


@always_inline("nodebug")
fn antiox(symbol: String) -> IntLiteral:
    if symbol == "i":
        return -1
    elif symbol == "o":
        return 0
    elif symbol == "x":
        return 1
    debug_assert(False, "invalid antiox")
    return 0


@always_inline("nodebug")
fn symbol[square: IntLiteral]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[SIMD[DType.index, 1](square)]()


@always_inline("nodebug")
fn symbol[square: FloatLiteral]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[SIMD[DType.float64, 1](square)]()


@always_inline("nodebug")
fn symbol[square: Int]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[SIMD[DType.index, 1](square)]()


@always_inline("nodebug")
fn symbol[type: DType, //, square: Scalar[type]]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        type: The data type of the square.
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """

    @parameter
    if square == -1:
        return "i"
    elif square == 0:
        return "o"
    elif square == 1:
        return "x"
    else:
        return "[" + str(square) + "]"


@always_inline("nodebug")
fn symbol(square: Int) -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Args:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol(SIMD[DType.index, 1](square))


@always_inline("nodebug")
fn symbol[type: DType, //](square: Scalar[type]) -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        type: The data type of the square.

    Args:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """

    if square == -1:
        return "i"
    elif square == 0:
        return "o"
    elif square == 1:
        return "x"
    else:
        return "[" + str(square) + "]"
