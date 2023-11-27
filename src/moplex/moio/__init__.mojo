"""
Implements the moio module.

Defines more io functions.
"""

@value
struct Moprintable:

    var string: String

    @always_inline
    fn __init__(inout self):
        self.string = ""

    @always_inline
    fn __init__(inout self, o: StringLiteral):
        self.string = o

    @always_inline
    fn __init__(inout self, o: String):
        self.string = o

    @always_inline
    fn __init__(inout self, o: IntLiteral):
        self.string = String(o)

    @always_inline
    fn __init__(inout self, o: FloatLiteral):
        self.string = String(o)

    @always_inline
    fn __init__(inout self, o: Int):
        self.string = String(o)

    @always_inline
    fn __init__[type: DType, size: Int](inout self, o: SIMD[type, size]):
        self.string = String(o)

    @always_inline
    fn __init__[square: Int](inout self, o: HybridIntLiteral[square]):
        let a = HybridInt[o.square](o)
        self.string = a.__str__()

    @always_inline
    fn __init__[square: FloatLiteral](inout self, o: HybridFloatLiteral[square]):
        self.string = o.__str__()

    @always_inline
    fn __init__[square: Int](inout self, o: HybridInt[square]):
        self.string = o.__str__()

    @always_inline
    fn __init__[type: DType, size: Int, square: SIMD[type,1]](inout self, o: HybridSIMD[type,size,square]):
        self.string = o.__str__()

    @always_inline
    fn __init__[type: DType, size: Int](inout self, o: MultiplexSIMD[type,size]):
        self.string = o.__str__()

alias no = ""

@always_inline
fn moprint(m0: Moprintable, m1: Moprintable = no, m2: Moprintable = no, m3: Moprintable = no, m4: Moprintable = no, m5: Moprintable = no, m6: Moprintable = no, m7: Moprintable = no):
    print(m0.string,m1.string,m2.string,m3.string,m4.string,m5.string,m6.string,m7.string)

fn moprint(): print()
fn moprint(o: IntLiteral): print(o)
fn moprint(o: FloatLiteral): print(o)
fn moprint(o: Int): print(o)
fn moprint(o: String): print(o)
fn moprint(o: StringLiteral): print(o)
fn moprint[dt: DType, sw: Int](o: SIMD[dt,sw]): print(o)

@always_inline
fn moprint[square: Int](o: HybridIntLiteral[square]): moprint(HybridInt(o))
fn moprint[square: FloatLiteral](o: HybridFloatLiteral[square]): print(o.__str__())
fn moprint[square: Int](o: HybridInt[square]): print(o.__str__())
fn moprint[type: DType, size: Int, square: SIMD[type,1]](o: HybridSIMD[type,size,square]): print(o.__str__())
fn moprint[type: DType, size: Int](o: MultiplexSIMD[type,size]): print(o.__str__())

# get the symbol for formatting
fn symbol[square: IntLiteral]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[square: FloatLiteral]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[square: Int]() -> String:
    """
    Gets the symbol corrosponding to a unit antiox.

    Parameters:
        square: The square of the antiox to find the symbol of.

    Returns:
        A string representing the unit antiox.
    """
    return symbol[DType.float64, SIMD[DType.float64,1](square)]()

fn symbol[type: DType, square: SIMD[type,1]]() -> String:
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
        return "[" + String(square) + "]"