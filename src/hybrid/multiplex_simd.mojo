# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #
"""The greater algebra containing Complex, Dualplex, and Hyperplex numbers."""

alias MultiplexInt8   = MultiplexSIMD[DType.int8, 1]
alias MultiplexUInt8  = MultiplexSIMD[DType.uint8, 1]
alias MultiplexInt16  = MultiplexSIMD[DType.int16, 1]
alias MultiplexUInt16 = MultiplexSIMD[DType.uint16, 1]
alias MultiplexInt32  = MultiplexSIMD[DType.int32, 1]
alias MultiplexUInt32 = MultiplexSIMD[DType.uint32, 1]
alias MultiplexInt64  = MultiplexSIMD[DType.int64, 1]
alias MultiplexUInt64 = MultiplexSIMD[DType.uint64, 1]
alias Multiplex16     = MultiplexSIMD[DType.float16, 1]
alias Multiplex32     = MultiplexSIMD[DType.float32, 1]
alias Multiplex64     = MultiplexSIMD[DType.float64, 1]


# +--------------------------------------------------------------------------+ #
# | MultiplexSIMD
# +--------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct MultiplexSIMD[type: DType, size: Int](StringableCollectionElement, Formattable):
    """
    Represents a multiplex simd type.
    
    Multiplex is the composition of complex, paraplex, and hyperplex numbers.

    Coefficients take precedence as the major axis istead of the SIMD axis.
    
    Parameters:
        type: The data type of MultiplexSIMD vector elements.
        size: The size of the MultiplexSIMD vector.
    """

    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    """Represents a SIMD coefficient."""

    alias Lane = MultiplexSIMD[type, 1]
    """Represents a single multiplex element."""


    # +------< Data >------+ #
    #
    var re: Self.Coef
    """The real part."""

    var i: Self.Coef
    """The complex antiox part."""

    var o: Self.Coef
    """The paraplex antiox part."""

    var x: Self.Coef
    """The hyperplex antiox part."""


    # +------( Initialize )------+ #
    #
    @always_inline # Coefficients
    fn __init__(inout self, re: Self.Coef = 0, i: Self.Coef = 0, o: Self.Coef = 0, x: Self.Coef = 0):
        """Initializes a MultiplexSIMD from coefficients."""
        self.re = re
        self.i = i
        self.o = o
        self.x = x

    @always_inline # Coefficients
    fn __init__[__:None=None](inout self, re: SIMD[type,1] = 0, i: SIMD[type,1] = 0, o: SIMD[type,1] = 0, x: SIMD[type,1] = 0):
        """Initializes a MultiplexSIMD from coefficients."""
        self.re = re
        self.i = i
        self.o = o
        self.x = x
    
    @always_inline # Scalar
    fn __init__(inout self, re: IntLiteral):
        """Initializes a MultiplexSIMD from a IntLiteral. Truncates if necessary."""
        self.re = re
        self.i = 0
        self.o = 0
        self.x = 0

    @always_inline # Scalar
    fn __init__(inout self, re: FloatLiteral):
        """Initializes a MultiplexSIMD from a FloatLiteral. Truncates if necessary."""
        self.re = re
        self.i = 0
        self.o = 0
        self.x = 0

    @always_inline # Scalar
    fn __init__(inout self, re: Int):
        """Initializes a MultiplexSIMD from an Int."""
        self.re = re
        self.i = 0
        self.o = 0
        self.x = 0

    @always_inline # Hybrid
    fn __init__(inout self, h: HybridIntLiteral):
        """Initializes a MultiplexSIMD from a unital HybridSIMD."""
        self = Self() + h

    @always_inline # Hybrid
    fn __init__(inout self, h: HybridFloatLiteral):
        """Initializes a MultiplexSIMD from a unital HybridIntLiteral."""
        self = Self() + h

    @always_inline # Hybrid
    fn __init__(inout self, h: HybridInt):
        """Initializes a MultiplexSIMD from a unital HybridInt."""
        self = Self() + h

    @always_inline # Hybrid
    fn __init__(inout self, h: HybridSIMD[type, size, _]):
        """Initializes a MultiplexSIMD from a unital HybridSIMD."""
        self = Self() + h

    @always_inline # Multiplex
    fn __init__(inout self, *m: Self.Lane):
        """Initializes a MultiplexSIMD from a variadic argument of multiplex elements."""
        var result: Self = Self{re:m[0].re, i:m[0].i, o:m[0].o, x:m[0].x}
        for i in range(len(m)):
            result.setlane(i, m[i])
        self = result


    # +------( Cast )------+ #
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when there are any non-zero parts."""
        return self.re == 0 and self.i == 0 and self.o == 0 and self.x == 0

    @always_inline
    fn is_zero(self) -> Bool:
        """Returns true when both parts of this multiplex number are zero."""
        return self.re == 0 and self.i == 0 and self.o == 0 and self.x == 0

    @always_inline
    fn is_null(self) -> Bool:
        """Returns true when this multiplex number has a measure of zero."""
        return self.measure() == 0

    fn to_tuple(self) -> (Self.Coef, Self.Coef, Self.Coef, Self.Coef):
        """Creates a non-algebraic StaticTuple from the multiplex parts."""
        return (self.re, self.i, self.o, self.x)

    fn cast[target: DType](self) -> MultiplexSIMD[target, size]:
        """Casts the elements of the MultiplexSIMD to the target element type."""
        return MultiplexSIMD[target,size](self.re.cast[target](), self.i.cast[target](), self.o.cast[target](), self.x.cast[target]())


    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        """Formats the multiplex as a String."""
        return String.format_sequence(self)

    @no_inline
    fn format_to(self, inout writer: Formatter):
        """Formats the multiplex as a String."""
        @parameter
        if size == 1:
            writer.write(self.re, " + ", self.i, "i + ", self.o, "o + ", self.x, "x")
        else:
            @parameter
            for index in range(size - 1):
                writer.write(self.getlane(index), "\n")
            writer.write(self.getlane(size - 1))


    # +------( Subscript )------+ #
    #
    @always_inline
    fn __getitem__(self, idx: Int) -> Self.Lane:
        return self.getlane(idx)
    
    @always_inline
    fn __setitem__(inout self, idx: Int, multiplex: Self.Lane):
        self.setlane(idx, multiplex)

    @always_inline
    fn getlane(self, idx: Int) -> Self.Lane:
        """
        Gets a multiplex element from the SIMD vector axis.

        Args:
            idx: The index of the multiplex element.

        Returns:
            The multiplex element at position `idx`.
        """
        return Self.Lane(self.re[idx], self.i[idx], self.o[idx], self.x[idx])
    
    @always_inline
    fn setlane(inout self, idx: Int, item: Self.Lane):
        """
        Sets a multiplex element in the SIMD vector axis.

        Args:
            idx: The index of the multiplex element.
            item: The multiplex element to insert at position `idx`.
        """
        self.re[idx] = item.re
        self.i[idx] = item.i
        self.o[idx] = item.o
        self.x[idx] = item.x

    @always_inline
    fn getcoef(self, idx: Int) -> Self.Coef:
        """
        Gets a coefficient at an index.

            0: Scalar
            1: Complex antiox
            2: Dualplex antiox
            3: Hyperplex antiox

        Args:
            idx: The index of the coefficient.

        Returns:
            The coefficient at the given index.
        """
        if idx == 0:
            return self.re
        if idx == 1:
            return self.i
        if idx == 2:
            return self.o
        if idx == 3:
            return self.x
        return 0
    
    @always_inline
    fn setcoef(inout self, idx: Int, coef: Self.Coef):
        """
        Sets a coefficient at an index.

            0: Scalar
            1: Complex antiox
            2: Dualplex antiox
            3: Hyperplex antiox

        Args:
            idx: The index of the coefficient.
            coef: The coefficient to insert at the given index.
        """
        if idx == 0:
            self.re = coef
        elif idx == 1:
            self.i = coef
        elif idx == 2:
            self.o = coef
        elif idx == 3:
            self.x = coef


    # +------( Unary )------+ #
    #
    @always_inline
    fn __neg__(self) -> Self:
        """Defines the unary `-` negative operator. Returns the negative of this multiplex number."""
        return Self(-self.re, -self.i, -self.o, -self.x)
    
    @always_inline
    fn __invert__(self) -> Self:
        """
        Defines the unary `~` invert operator. Performs bit-wise invert.
        
        SIMD type must be integral (or boolean).

        Returns:
            The bit-wise inverted multiplex number.
        """
        return Self(~self.re, ~self.i, ~self.o, ~self.x) # could define different behaviour. bit invert is not used very often with complex types.
    
    @always_inline
    fn conjugate(self) -> Self:
        """
        Gets the conjugate of this multiplex number.

        This is also called the hodge dual, and reverses the order of coefficients.

            conjugate(Multiplex(s,i,o,x)) = Multiplex(s,-i,-o,-x)

        Returns:
            The multiplex conjugate.
        """
        return Self(self.re, -self.i, -self.o, -self.x)

    @always_inline
    fn denomer[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the denomer of this multiplex number.

        Equal to the measure squared for non-degenerate cases.

            # coefficient math:
            c[0]*c[0] + (c[1]-c[2])**2 - c[2]*c[2] - c[3]*c[3]

        Parameters:
            absolute: Setting this to true will ensure a positive result by taking the absolute value.

        Returns:
            The multiplex denomer.
        """
        var io = self.i-self.o
        var result = self.re*self.re + io*io - self.o*self.o - self.x*self.x
        @parameter
        if absolute: return abs(result)
        else: return result

    @always_inline
    fn measure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the measure of this multiplex number.
        
        This is similar to magnitude, but is not guaranteed to be positive.

        Equal to the square root of the denomer.

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute denomer.

        Returns:
            The multiplex measure.
        """
        return sqrt(self.denomer[absolute]())

    @always_inline
    fn antidenomer[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the antidenomer of this multiplex number.
        
        Equal to the antimeasure squared for non-degenerate cases.

            # coefficient math:
            -(c[1]-c[2])**2 + c[2]*c[2] + c[3]*c[3])

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute before the sqrt.

        Returns:
            The multiplex antidenomer.
        """
        var io = self.i-self.o
        var result = -io*io + self.o*self.o + self.x*self.x
        @parameter
        if absolute: return abs(result)
        else: return result

    @always_inline
    fn antimeasure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the hybridian of this multiplex number.
        
        Together with measure, this multiplex number can be characterized.

        Equal to the square root of the antidenomer.

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute before the sqrt.

        Returns:
            The multiplex antimeasure.
        """
        return sqrt(self.antidenomer[absolute]())

    # @always_inline
    # fn characterize() -> StaticIntTuple[2]

    # @always_inline
    # fn argument[branch: Int = 0](self) -> Self.Coef:
    #     """Gets the argument of this multiplex number."""
    #     var m = self.antidenomer()
    #     if m < 0:
    #         if self.s < 0: return pi - atan2(self.antimeasure(), self.re)
    #         else: return atan2(self.antimeasure(), self.re)
    #     elif m > 0


    # # +------( Products )------+ #
    # #
    # @always_inline
    # fn inner(self, other: Self) -> Self.Coef:
    #     """
    #     The inner product of two hybrid numbers.

    #     This is the scalar part of the conjugate product.

    #         (h1.conjugate()*h2).re

    #     Args:
    #         other: The other hybrid number.

    #     Returns:
    #         The result of taking the outer product.
    #     """
    #     @parameter
    #     if square == 0: return self.re*other.re
    #     return self.re*other.re - square*self.im*other.im

    # @always_inline
    # fn outer(self, other: Self) -> Self:
    #     """
    #     The outer product of two hybrid numbers.

    #     This is the hybridian part of the conjugate product.

    #         (h1.conjugate()*h2).im

    #     Args:
    #         other: The other hybrid number.

    #     Returns:
    #         The result of taking the outer product.
    #     """
    #     return Self(0, self.re*other.im - self.im*other.re)


    # +------( Arithmetic )------+ #
    #
    # +--- addition
    @always_inline # Multiplex + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.re + other, self.i, self.o, self.x)

    @always_inline # Multiplex + Hybrid
    fn __add__(self, other: HybridSIMD[type, size, _]) -> Self:
        var unital = other.unitize()
        @parameter
        if unital.square == -1:
            return Self(self.re + unital.re, self.i + unital.im, self.o, self.x)
        elif unital.square == 0:
            return Self(self.re + unital.re, self.i, self.o + unital.im, self.x)
        else:
            return Self(self.re + unital.re, self.i, self.o, self.x + unital.im)

    @always_inline # Multiplex + Multiplex
    fn __add__[__:None=None, ___:None=None](self, other: Self) -> Self:
        return Self(self.re + other.re, self.i + other.i, self.o + other.o, self.x + other.x)

    # +--- subtraction
    @always_inline # Multiplex - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.re - other, self.i, self.o, self.x)

    @always_inline # Multiplex - Hybrid
    fn __sub__(self, other: HybridSIMD[type, size, _]) -> Self:
        var unital = other.unitize()
        @parameter
        if unital.square == -1:
            return Self(self.re - unital.re, self.i - unital.im, self.o, self.x)
        elif unital.square == 0:
            return Self(self.re - unital.re, self.i, self.o - unital.im, self.x)
        else:
            return Self(self.re - unital.re, self.i, self.o, self.x - unital.im)

    @always_inline # Multiplex - Multiplex
    fn __sub__[__:None=None, ___:None=None](self, other: Self) -> Self:
        return Self(self.re - other.re, self.i - other.i, self.o - other.o, self.x - other.x)

    # +--- multiplication
    @always_inline # Multiplex * Scalar
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.re*other, self.i*other, self.o*other, self.x*other)

    @always_inline # Multiplex * Multiplex
    fn __mul__[__:None=None](self, other: Self) -> Self:
        return Self(
            self.re*other.re - self.i*other.i + self.i*other.o + self.o*other.i + self.x*other.x,
            self.re*other.i + self.i*other.re + self.i*other.x - self.x*other.i,
            self.re*other.o + self.i*other.x + self.o*other.re - self.o*other.x - self.x*other.i + self.x*other.o,
            self.re*other.x - self.i*other.o + self.o*other.i + self.x*other.re)

    # +--- division
    @always_inline # Multiplex / Scalar
    fn __truediv__(self, other: Self.Coef) -> Self:
        return self * (1/other)

    @always_inline # Multiplex / Multiplex
    fn __truediv__[__:None=None](self, other: Self) -> Self:
        return self*other.conjugate() / other.denomer()

    @always_inline # Multiplex // Scalar
    fn __floordiv__(self, other: Self.Coef) -> Self:
        return Self(self.re//other, self.i//other, self.o//other, self.x//other)

    @always_inline # Multiplex // Multiplex
    fn __floordiv__[__:None=None](self, other: Self) -> Self:
        return self*other.conjugate() // other.denomer()

    
    # +------( Reverse Arithmetic )------+ #
    #
    # +--- addition
    @always_inline # Scalar + Multiplex
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.re, self.i, self.o, self.x)

    @always_inline # Hybrid + Multiplex
    fn __radd__(self, other: HybridSIMD[type, size, _]) -> Self:
        var unital = other.unitize()
        @parameter
        if unital.square == -1:
            return Self(unital.re + self.re, unital.im + self.i, self.o, self.x)
        elif unital.square == 0:
            return Self(unital.re + self.re, self.i, unital.im + self.o, self.x)
        else:
            return Self(unital.re + self.re, self.i, self.o, unital.im + self.x)

    @always_inline # Multiplex + Multiplex
    fn __radd__[__:None=None, ___:None=None](self, other: Self) -> Self:
        return other + self

    # +--- subtraction
    @always_inline # Scalar - Multiplex
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.re, -self.i, -self.o, -self.x)

    @always_inline # Hybrid - Multiplex
    fn __rsub__(self, other: HybridSIMD[type, size, _]) -> Self:
        var unital = other.unitize()
        @parameter
        if unital.square == 1:
            return Self(unital.re - self.re, unital.im - self.i, -self.o, -self.x)
        elif unital.square == -1:
            return Self(unital.re - self.re, -self.i, unital.im - self.o, -self.x)
        else:
            return Self(unital.re - self.re, -self.i, -self.o, unital.im - self.x)

    @always_inline # Multiplex - Multiplex
    fn __rsub__[__:None=None, ___:None=None](self, other: Self) -> Self:
        return other - self

    # +--- multiplication
    @always_inline # Scalar * Multiplex
    fn __rmul__(self, other: Self.Coef) -> Self:
        return Self(other*self.re, other*self.i, other*self.o, other*self.x)

    @always_inline # Multiplex * Multiplex
    fn __rmul__[__:None=None](self, other: Self) -> Self:
        return other * self

    # +--- division
    @always_inline # Scalar / Multiplex
    fn __rtruediv__(self, other: Self.Coef) -> Self:
        return other*self.conjugate() / self.denomer()

    @always_inline # Multiplex / Multiplex
    fn __rtruediv__[__:None=None](self, other: Self) -> Self:
        return other / self

    @always_inline # Scalar // Multiplex
    fn __rfloordiv__(self, other: Self.Coef) -> Self:
        return other*self.conjugate() // self.denomer()

    @always_inline # Multiplex // Multiplex
    fn __rfloordiv__[__:None=None](self, other: Self) -> Self:
        return other // self


    # +------( In Place Arithmetic )------+ #
    #
    # +--- addition
    @always_inline # Multiplex += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline # Multiplex += Hybrid
    fn __iadd__(inout self, other: HybridSIMD[type, size, _]):
        self = self + other
    
    @always_inline # Multiplex += Multiplex
    fn __iadd__[__:None=None](inout self, other: Self):
        self = self + other

    # +--- subtraction
    @always_inline # Multiplex -= Scalar
    fn __isub__(inout self, other: Self.Coef):
        self = self - other

    @always_inline # Multiplex -= Hybrid
    fn __isub__(inout self, other: HybridSIMD[type, size, _]):
        self = self - other
    
    @always_inline # Multiplex -= Multiplex
    fn __isub__[__:None=None](inout self, other: Self):
        self = self - other

    # +--- multiplication
    @always_inline # Multiplex *= Scalar
    fn __imul__(inout self, other: Self.Coef):
        self = self * other
    
    @always_inline # Multiplex *= Multiplex
    fn __imul__[__:None=None](inout self, other: Self):
        self = self * other

    # +--- division
    @always_inline # Multiplex /= Scalar
    fn __itruediv__(inout self, other: Self.Coef):
        self = self / other
    
    @always_inline # Multiplex /= Multiplex
    fn __itruediv__[__:None=None](inout self, other: Self):
        self = self / other

    @always_inline # Multiplex //= Scalar
    fn __ifloordiv__(inout self, other: Self.Coef):
        self = self // other
    
    @always_inline # Multiplex //= Multiplex
    fn __ifloordiv__[__:None=None](inout self, other: Self):
        self = self // other