# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Implements a hybrid floating point literal."""


alias ComplexFloatLiteral = HybridFloatLiteral[-1]
alias DualplexFloatLiteral = HybridFloatLiteral[0]
alias HyperplexFloatLiteral = HybridFloatLiteral[1]


# TODO: Fix hack for converting hybrid literal to strings
struct RunTimeHybridFloatLiteral:
    var re: Float64
    var im: Float64
    var sq: Float64

    fn __init__(inout self, lit: HybridFloatLiteral):
        self.re = lit.re
        self.im = lit.im
        self.sq = lit.square

    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        """Formats the hybrid as a String."""
        return String.format_sequence(self)

    @no_inline
    fn format_to(self, inout writer: Formatter):
        """Formats the hybrid as a String."""
        writer.write(self.re, " + ", self.im, symbol(self.sq))


# +----------------------------------------------------------------------------------------------+ #
# | Hybrid Float Literal
# +----------------------------------------------------------------------------------------------+ #
#
@nonmaterializable(RunTimeHybridFloatLiteral)
@register_passable("trivial")
struct HybridFloatLiteral[square: FloatLiteral](CollectionElement, EqualityComparable):
    """
    Represent a hybrid floating point literal with scalar and antiox parts.

    Parameterized on the antiox squared.

        square = antiox*antiox

    Parameters:
        square: The value of the antiox unit squared.
    """

    # +------[ Alias ]------+ #
    #
    alias Coef = FloatLiteral
    """Represents a floating point literal coefficient."""

    alias unital_square = sign(square)
    """The normalized square."""

    alias unital_factor = ufac(square)
    """The unitization factor."""

    # +------< Data >------+ #
    #
    var re: Self.Coef
    """The real part."""

    var im: Self.Coef
    """The anti part."""

    # +------( Initialize )------+ #
    #
    @always_inline  # Coefficients
    fn __init__(inout self, re: Self.Coef = 0, im: Self.Coef = 0):
        """Initializes a HybridFloatLiteral from coefficients."""
        self.re = re
        self.im = im

    @always_inline  # Scalar
    fn __init__(inout self, re: IntLiteral):
        """Initializes a HybridFloatLiteral from an IntLiteral."""
        self.re = re
        self.im = 0

    @always_inline  # Hybrid
    fn __init__(inout self, h: HybridIntLiteral[square]):
        """Initializes a HybridFloatLiteral from a HybridIntLiteral."""
        self.re = h.re
        self.im = h.im

    # +------( Cast )------+ #
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when this hybrid number has a non zero measure."""
        return not self.is_null()

    @always_inline
    fn is_zero(self) -> Bool:
        """Returns true when both parts of this hybrid number are zero."""
        return self.re == 0 and self.im == 0

    @always_inline
    fn is_null(self) -> Bool:
        """Returns true when this hybrid number has a measure of zero."""
        return contrast(self) == 0

    @always_inline
    fn __hybrid_int__(self) -> HybridInt[square]:
        """Casts the value to a HybridInt. The fractional components are truncated towards zero."""
        return HybridInt[square](int(self.re), int(self.im))

    @always_inline
    fn __hybrid_int_literal__(self) -> HybridIntLiteral[square]:
        """Casts the value to a HybridIntLiteral. The fractional components are truncated towards zero.
        """
        return HybridIntLiteral[square](self.re.__int_literal__(), self.im.__int_literal__())

    @always_inline
    fn to_tuple(self) -> (Self.Coef, Self.Coef):
        """Creates a non-algebraic Tuple from the hybrids coefficients."""
        return Tuple[Self.Coef, Self.Coef](self.re, self.im)

    @always_inline
    fn unitize(self) -> HybridFloatLiteral[Self.unital_square]:
        """Unitize the HybridFloatLiteral, this normalizes the square and adjusts the antiox coefficient.
        """
        return HybridFloatLiteral[Self.unital_square](self.re, self.im * Self.unital_factor)

    @always_inline
    fn unitize[target_square: FloatLiteral](self) -> HybridFloatLiteral[target_square]:
        """Unitize the HybridFloatLiteral. Sets the square and adjusts the antiox coefficient."""
        constrained[
            sign(square) == sign(target_square),
            "cannot unitize: the squares signs must match",
        ]()
        alias factor = ufac(square) / ufac(target_square)
        return HybridFloatLiteral[target_square](self.re, self.im * factor)

    # +------( Format )------+ #
    #
    # TODO: Fix hack for converting hybrid literal to strings

    # +------( Subscript )------+ #
    #
    @always_inline
    fn __getattr__[key: StringLiteral](self) -> FloatLiteral:
        return self.get_antiox[antiox(key)]()

    @always_inline
    fn __setattr__[key: StringLiteral](inout self, val: FloatLiteral):
        self.set_antiox[antiox(key)](val)

    @always_inline
    fn getcoef(self, idx: Int) -> Self.Coef:
        """
        Gets a coefficient at an index.

            0: scalar
            1: antiox

        Args:
            idx: The index of the coefficient.

        Returns:
            The coefficient at the given index.
        """
        if idx == 0:
            return self.re
        if idx == 1:
            return self.im
        return 0

    @always_inline
    fn setcoef(inout self, idx: Int, coef: Self.Coef):
        """
        Sets a coefficient at an index.

            0: scalar
            1: antiox

        Args:
            idx: The index of the coefficient.
            coef: The coefficient to insert at the given index.
        """
        if idx == 0:
            self.re = coef
        elif idx == 1:
            self.im = coef

    @always_inline
    fn get_antiox[_square: FloatLiteral](self) -> Self.Coef:
        constrained[
            sign(square) == sign(_square),
            "cannot get antiox. the sign of squares must match",
        ]()
        return self.im * (Self.unital_factor / ufac(_square))

    @always_inline
    fn set_antiox[_square: FloatLiteral](inout self, antiox: Self.Coef):
        constrained[
            sign(square) == sign(_square),
            "cannot set antiox. the sign of squares must match",
        ]()
        self.im = (antiox * (ufac(_square) / Self.unital_factor)).__int_literal__()

    # +------( Min / Max )------+ #
    #
    @always_inline
    fn min(self, other: Self) -> Self:
        """Return the value which is closest to negative infinity."""
        if self < other:
            return self
        else:
            return other

    @always_inline
    fn max(self, other: Self) -> Self:
        """Return the value which is closest to positive infinity."""
        if self > other:
            return self
        else:
            return other

    # +------( Comparison )------+ #
    #
    @always_inline
    fn __lt__(self, other: Self) -> Bool:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's.
        """
        return contrast(self) < contrast(other)

    @always_inline
    fn __lt__(self, other: Self.Coef) -> Bool:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's.
        """
        return contrast(self) < contrast[square](other)

    @always_inline
    fn __le__(self, other: Self) -> Bool:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's.
        """
        return contrast(self) <= contrast(other)

    @always_inline
    fn __le__(self, other: Self.Coef) -> Bool:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's.
        """
        return contrast(self) <= contrast[square](other)

    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.re == other.re and self.im == other.im

    @always_inline
    fn __eq__(self, other: Self.Coef) -> Bool:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.re == other and self.im == 0

    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal.
        """
        return self.re != other.re or self.im != other.im

    @always_inline
    fn __ne__(self, other: Self.Coef) -> Bool:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal.
        """
        return self.re != other or self.im != 0

    @always_inline
    fn __gt__(self, other: Self) -> Bool:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's.
        """
        return contrast(self) > contrast(other)

    @always_inline
    fn __gt__(self, other: Self.Coef) -> Bool:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's.
        """
        return contrast(self) > contrast[square](other)

    @always_inline
    fn __ge__(self, other: Self) -> Bool:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's.
        """
        return contrast(self) >= contrast(other)

    @always_inline
    fn __ge__(self, other: Self.Coef) -> Bool:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's.
        """
        return contrast(self) >= contrast[square](other)

    # +------( Unary )------+ #
    #
    @always_inline
    fn __neg__(self) -> Self:
        """Defines the unary `-` negative operator. Returns the negative of this hybrid number."""
        return Self(-self.re, -self.im)

    @always_inline
    fn conjugate(self) -> Self:
        """
        Gets the conjugate of this hybrid number.

            conjugate(Hybrid(s,a)) = Hybrid(s,-a)

        Returns:
            The hybrid conjugate.
        """
        return Self(self.re, -self.im)

    @always_inline
    fn denomer[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the denomer of this hybrid number.

        Equal to the measure squared for non-degenerate cases.

            # coefficient math:
            Complex   -> c[0]*c[0] + c[1]*c[1]
            Dualplex  -> c[0]*c[0]
            Hyperplex -> c[0]*c[0] - c[1]*c[1]

        Parameters:
            absolute: Setting this to true will ensure a positive result by taking the absolute value.

        Returns:
            The hybrid denomer.
        """

        @parameter
        if absolute:
            return abs(self.inner(self))
        return self.inner(self)

    @always_inline
    fn measure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the measure of this hybrid number.

        This is similar to magnitude, but is not guaranteed to be positive when the antiox squared is positive.

        Equal to the square root of the denomer.

            # coefficient math:
            Complex   -> sqrt(c[0]*c[0] + c[1]*c[1])
            Dualplex  -> sqrt(c[0]*c[0])
            Hyperplex -> sqrt(c[0]*c[0] - c[1]*c[1])

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute denomer.

        Returns:
            The hybrid measure.
        """

        @parameter
        if square != 0:
            return sqrt(self.denomer[absolute]())
        return abs(self.re)

    @always_inline
    fn lmeasure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the lmeasure of this hybrid number.

        Equal to the natural log of the measure.

        Parameters:
            absolute: Setting this true will ensure a definite result.

        Returns:
            The hybrid lmeasure.
        """

        @parameter
        if square == 0:
            return log_(self.measure())
        else:
            return log_(self.denomer[absolute]()) / 2

    @always_inline
    fn argument[branch: Int = 0](self) -> FloatLiteral:
        """Gets the argument of this hybrid number."""

        @parameter
        if square == -1:
            abort("not implemented")
            return 0
            # return atan(self.im / self.re) + branch * pi
        elif square == 0:
            return self.im / self.re
        elif square == 1:
            abort("not implemented")
            return 0
            # return atanh(self.im / self.re)
        else:
            return self.unitize().argument() / Self.unital_factor

    @always_inline
    fn normalized(self) -> Self:
        return self / self.measure()

    # +------( Products )------+ #
    #
    @always_inline
    fn inner(self, other: Self) -> Self.Coef:
        """
        The inner product of two hybrid numbers.

        This is the scalar part of the conjugate product.

            (h1.conjugate()*h2).s

        Args:
            other: The other hybrid number.

        Returns:
            The result of taking the outer product.
        """

        @parameter
        if square == 0:
            return self.re * other.re
        return self.re * other.re - square * self.im * other.im

    @always_inline
    fn outer(self, other: Self) -> Self:
        """
        The outer product of two hybrid numbers.

        This is the antiox part of the conjugate product.

            (h1.conjugate()*h2).a

        Args:
            other: The other hybrid number.

        Returns:
            The result of taking the outer product.
        """
        return Self(0, self.re * other.im - self.im * other.re)

    # +------( Arithmetic )------+ #
    #
    # +--- addition
    @always_inline  # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.re + other, self.im)

    @always_inline  # Hybrid + Hybrid
    fn __add__[__: None = None](self, other: Self) -> Self:
        return Self(self.re + other.re, self.im + other.im)

    # +--- subtraction
    @always_inline  # Hybrid - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.re - other, self.im)

    @always_inline  # Hybrid - Hybrid
    fn __sub__[__: None = None](self, other: Self) -> Self:
        return Self(self.re - other.re, self.im - other.im)

    # +--- multiplication
    @always_inline  # Hybrid * Scalar
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.re * other, self.im * other)

    @always_inline  # Hybrid * Hybrid
    fn __mul__[__: None = None](self, other: Self) -> Self:
        return Self(
            self.re * other.re + square * self.im * other.im,
            self.re * other.im + self.im * other.re,
        )

    # +--- division
    @always_inline  # Hybrid / Scalar
    fn __truediv__(self, other: Self.Coef) -> Self:
        return self * (1 / other)

    @always_inline  # Hybrid / Hybrid
    fn __truediv__[__: None = None](self, other: Self) -> Self:
        return self * other.conjugate() / other.denomer()

    @always_inline  # Hybrid // Scalar
    fn __floordiv__(self, other: Self.Coef) -> HybridIntLiteral[square]:
        return (self / other).__hybrid_int_literal__()

    @always_inline  # Hybrid // Hybrid
    fn __floordiv__[__: None = None](self, other: Self) -> HybridIntLiteral[square]:
        return self * other.conjugate() // other.denomer()

    # +--- exponentiation
    @always_inline  # Hybrid ** Scalar
    fn __pow__[branch: IntLiteral = 0](self, other: Self.Coef) -> Self:
        if other == 1:
            return self
        elif other == 2:
            return self * self
        elif other == 3:
            return self * self * self
        else:

            @parameter
            if square == 0:
                return pow_(self.re, other - 1) * Self(self.re, self.im * other)
            else:
                return exp(other * log[branch](self))

    @always_inline  # Hybrid ** Hybrid
    fn __pow__[branch: IntLiteral = 0](self, other: Self) -> Self:
        if other == 1.0:
            return self
        elif other == 2.0:
            return self * self
        elif other == 3.0:
            return self * self * self
        else:

            @parameter
            if square == 0:
                return pow_(self.re, other.re - 1) * Self(
                    self.re,
                    other.im * self.re * log_(self.re) + self.im * other.re,
                )
            else:
                return exp(other * log[branch](self))

    # +------( Reverse Arithmetic )------+ #
    #
    # +--- addition
    @always_inline  # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.re, self.im)

    @always_inline  # Hybrid + Hybrid
    fn __radd__[__: None = None](self, other: Self) -> Self:
        return other + self

    # +--- subtraction
    @always_inline  # Scalar - Hybrid
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.re, -self.im)

    @always_inline  # Hybrid - Hybrid
    fn __rsub__[__: None = None](self, other: Self) -> Self:
        return other - self

    # +--- multiplication
    @always_inline  # Scalar * Hybrid
    fn __rmul__(self, other: Self.Coef) -> Self:
        return Self(other * self.re, other * self.im)

    @always_inline  # Hybrid * Hybrid
    fn __rmul__[__: None = None](self, other: Self) -> Self:
        return other * self

    # +--- division
    @always_inline  # Scalar / Hybrid
    fn __rtruediv__(self, other: Self.Coef) -> Self:
        return other * self.conjugate() / self.denomer()

    @always_inline  # Hybrid / Hybrid
    fn __rtruediv__[__: None = None](self, other: Self) -> Self:
        return other / self

    @always_inline  # Scalar // Hybrid
    fn __rfloordiv__(self, other: Self.Coef) -> HybridIntLiteral[square]:
        return other * self.conjugate() // self.denomer()

    @always_inline  # Hybrid // Hybrid
    fn __rfloordiv__[__: None = None](self, other: Self) -> HybridIntLiteral[square]:
        return other // self

    # +--- exponentiation
    @always_inline  # Scalar ** Hybrid
    fn __rpow__(self, other: Self.Coef) -> Self:
        return exp(self * log_(other))

    @always_inline  # Hybrid ** Hybrid
    fn __rpow__(self, other: Self) -> Self:
        return other**self

    # +------( In Place Arithmetic )------+ #
    #
    # +--- addition
    @always_inline  # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other

    @always_inline  # Hybrid += Hybrid
    fn __iadd__[__: None = None](inout self, other: Self):
        self = self + other

    # +--- subtraction
    @always_inline  # Hybrid -= Scalar
    fn __isub__(inout self, other: Self.Coef):
        self = self - other

    @always_inline  # Hybrid -= Hybrid
    fn __isub__[__: None = None](inout self, other: Self):
        self = self - other

    # +--- multiplication
    @always_inline  # Hybrid *= Scalar
    fn __imul__(inout self, other: Self.Coef):
        self = self * other

    @always_inline  # Hybrid *= Hybrid
    fn __imul__[__: None = None](inout self, other: Self):
        self = self * other

    # +--- division
    @always_inline  # Hybrid /= Scalar
    fn __itruediv__(inout self, other: Self.Coef):
        self = self / other

    @always_inline  # Hybrid /= Hybrid
    fn __itruediv__[__: None = None](inout self, other: Self):
        self = self / other

    @always_inline  # Hybrid //= Scalar
    fn __ifloordiv__(inout self, other: Self.Coef):
        self = self // other

    @always_inline  # Hybrid //= Hybrid
    fn __ifloordiv__[__: None = None](inout self, other: Self):
        self = self // other

    # +--- exponentiation
    # @always_inline # Hybrid **= Scalar
    # fn __ipow__(inout self, other: Self.Coef):
    #     self = self ** other

    # @always_inline # Hybrid **= Hybrid
    # fn __ipow__[__:None=None](inout self, other: Self):
    #     self = self ** other
