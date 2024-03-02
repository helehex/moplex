"""
Implements a hybrid floating point literal, parameterized on the antiox squared.
"""


from ..io import *
from ..math import *

alias ComplexFloatLiteral = HybridFloatLiteral[-1]
alias ParaplexFloatLiteral = HybridFloatLiteral[0]
alias HyperplexFloatLiteral = HybridFloatLiteral[1]

fn constrain_square[a: FloatLiteral, b: Int]():
    constrained[a == b, "mismatched 'square' parameter"]()

# fn integral_counterpart[square: FloatLiteral]() -> AnyType:
#     @parameter
#     if square == square.to_int(): return HybridIntLiteral[square.to_int()]
#     else: return NoneType


#------------ Hybrid Float Literal ------------#
#---
#---
@register_passable("trivial")
struct HybridFloatLiteral[square: FloatLiteral](Stringable):
    """
    Represent a hybrid floating point literal with scalar and antiox parts.

    Parameterized on the antiox squared.

        square = antiox*antiox
    
    Parameters:
        square: The value of the antiox unit squared.
    """


    #------[ Alias ]------#
    #
    alias Coef = FloatLiteral
    """Represents a floating point literal coefficient."""

    alias unital_square: FloatLiteral = sign(square)
    """The normalized square."""
    

    #------< Data >------#
    #
    var s: Self.Coef
    """The scalar part."""

    var a: Self.Coef
    """The antiox part."""
    
    
    #------( Initialize )------#
    #
    @always_inline # Coefficients
    fn __init__(s: Self.Coef = 0, a: Self.Coef = 0) -> Self:
        """Initializes a HybridFloatLiteral from coefficients."""
        return Self{s:s, a:a}

    @always_inline # Scalar
    fn __init__(s: IntLiteral) -> Self:
        """Initializes a HybridFloatLiteral from an IntLiteral."""
        return Self{s:s, a:0}

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral) -> Self:
        """Initializes a HybridFloatLiteral from a HybridIntLiteral."""
        constrain_square[square, h.square]()
        return Self{s:h.s, a:h.a}
    
    # @always_inline # Hybrid
    # fn __init__(h: integral_counterpart[square]()) -> Self:
    #     """Initializes a HybridFloatLiteral from a HybridIntLiteral."""
    #     var h_ = rebind[HybridIntLiteral[square.to_int()], integral_counterpart[square]()](h)
    #     constrain_square[square, h_.square]()
    #     return Self{s:h_.s, a:h_.a}


    #------( To )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when there are any non-zero parts."""
        return self.s.__bool__() or self.a.__bool__()

    @always_inline
    fn nil(self) -> Bool:
        """Returns true when this hybrid number has a non zero measure."""
        return self.contrast() != 0

    @always_inline
    fn to_int(self) -> HybridInt[square.to_int()]:
        """Casts the value to a HybridInt. The fractional components are truncated towards zero."""
        return HybridInt[square.to_int()](self.s.to_int(), self.a.to_int())

    @always_inline
    fn to_tuple(self) -> StaticTuple[2, Self.Coef]:
        """Creates a non-algebraic StaticTuple from the hybrids parts."""
        return StaticTuple[2, Self.Coef](self.s, self.a)

    @always_inline
    fn to_unital(self) -> HybridFloatLiteral[Self.unital_square]:
        """Unitize the HybridInt, this normalizes the square and adjusts the antiox coefficient."""
        @parameter
        if Self.unital_square == 1: return HybridFloatLiteral[Self.unital_square](self.s, self.a * sqrt(square))
        elif Self.unital_square == -1: return HybridFloatLiteral[Self.unital_square](self.s, self.a * sqrt(-square))
        else: return HybridFloatLiteral[Self.unital_square](self.s, self.a)
    
    
    #------( Formatting )------#
    #
    @always_inline
    fn to_string(self) -> String:
        """Formats the hybrid as a String."""
        return self.__str__()

    @always_inline
    fn __str__(self) -> String:
        """Formats the hybrid as a String."""
        return String(self.s) + " + " + String(self.a) + symbol[square]()


    #------( Get / Set )------#
    #
    @always_inline
    fn __getitem__(self, idx: Int) -> Self.Coef:
        """
        Gets a coefficient at an index.

            0: scalar
            1: antiox

        Args:
            idx: The index of the coefficient.

        Returns:
            The coefficient at the given index.
        """
        if idx == 0: return self.s
        if idx == 1: return self.a
        return 0
    
    @always_inline
    fn __setitem__(inout self, idx: Int, coef: Self.Coef):
        """
        Sets a coefficient at an index.

            0: scalar
            1: antiox

        Args:
            idx: The index of the coefficient.
            coef: The coefficient to insert at the given index.
        """
        if idx == 0: self.s = coef
        elif idx == 1: self.a = coef


    #------( Comparison )------#
    #
    @always_inline
    fn __lt__(self, other: Self) -> Bool:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's."""
        return self.contrast() < other.contrast()

    @always_inline
    fn __lt__(self, other: Self.Coef) -> Bool:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's."""
        @parameter
        if square == 0: return self.measure() < abs(other)
        else: return self.denomer() < other*other

    @always_inline
    fn __le__(self, other: Self) -> Bool:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's."""
        return self.contrast() <= other.contrast()

    @always_inline
    fn __le__(self, other: Self.Coef) -> Bool:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's."""
        @parameter
        if square == 0: return self.measure() <= abs(other)
        else: return self.denomer() <= other*other

    @always_inline
    fn __eq__(self, other: Self) -> Bool:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.s == other.s and self.a == other.a

    @always_inline
    fn __eq__(self, other: Self.Coef) -> Bool:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.s == other and self.a == 0
    
    @always_inline
    fn __ne__(self, other: Self) -> Bool:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal."""
        return self.s != other.s or self.a != other.a

    @always_inline
    fn __ne__(self, other: Self.Coef) -> Bool:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal."""
        return self.s != other or self.a != 0

    @always_inline
    fn __gt__(self, other: Self) -> Bool:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's."""
        return self.contrast() > other.contrast()

    @always_inline
    fn __gt__(self, other: Self.Coef) -> Bool:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's."""
        @parameter
        if square == 0: return self.measure() > abs(other)
        else: return self.denomer() > other*other

    @always_inline
    fn __ge__(self, other: Self) -> Bool:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's."""
        return self.contrast() >= other.contrast()

    @always_inline
    fn __ge__(self, other: Self.Coef) -> Bool:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's."""
        @parameter
        if square == 0: return self.measure() >= abs(other)
        else: return self.denomer() >= other*other


    #------( Unary )------#
    #
    @always_inline
    fn __neg__(self) -> Self:
        """Defines the unary `-` negative operator. Returns the negative of this hybrid number."""
        return Self(-self.s, -self.a)
    
    @always_inline
    fn conjugate(self) -> Self:
        """
        Gets the conjugate of this hybrid number.

            conjugate(Hybrid(s,a)) = Hybrid(s,-a)

        Returns:
            The hybrid conjugate.
        """
        return Self(self.s, -self.a)

    @always_inline
    fn denomer[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the denomer of this hybrid number.

        Equal to the measure squared for non-degenerate cases.

            # coefficient math:
            Complex   -> c[0]*c[0] + c[1]*c[1]
            Paraplex  -> c[0]*c[0]
            Hyperplex -> c[0]*c[0] - c[1]*c[1]

        Parameters:
            absolute: Setting this to true will ensure a positive result by taking the absolute value.

        Returns:
            The hybrid denomer.
        """
        @parameter
        if absolute: return abs(self.inner(self))
        return self.inner(self)

    @always_inline
    fn contrast(self) -> Self.Coef:
        """Uses the fastest way to compare two hybrid numbers."""
        @parameter
        if square == 0: return self.measure()
        else: return self.denomer()

    @always_inline
    fn measure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the measure of this hybrid number.
        
        This is similar to magnitude, but is not guaranteed to be positive when the antiox squared is positive.

        Equal to the square root of the denomer.

            # coefficient math:
            Complex   -> sqrt(c[0]*c[0] + c[1]*c[1])
            Paraplex  -> sqrt(c[0]*c[0])
            Hyperplex -> sqrt(c[0]*c[0] - c[1]*c[1])

        Parameters:
            absolute: Setting this to true will ensure a positive result by using the absolute denomer.

        Returns:
            The hybrid measure.
        """
        @parameter
        if square != 0: return sqrt(self.denomer[absolute]())
        return abs(self.s)

    @always_inline
    fn argument[branch: Int = 0](self) -> Self.Coef:
        """Gets the argument of this hybrid number. *Work in progress, may change."""
        @parameter
        if square == -1: return atan2(self.a, self.s) + branch*tau
        elif square == 0: return self.a/self.s
        elif square == 1: return log(abs(self.s + self.a) / self.measure[True]())
        else:
            print("not implemented in general case, maybe unitize would work but it's broken")
            return 0

    @always_inline
    fn normalized(self) -> Self:
        return self / self.measure()


    #------( Products )------#
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
        if square == 0: return self.s*other.s
        return self.s*other.s - square*self.a*other.a

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
        return Self(0, self.s*other.a - self.a*other.s)

    
    #------( Arithmetic )------#
    #
    #--- addition
    @always_inline # Hybrid + Scalar
    fn __add__(self, other: Self.Coef) -> Self:
        return Self(self.s + other, self.a)
    
    @always_inline # Hybrid + Hybrid
    fn __add__[__:None=None](self, other: Self) -> Self:
        return Self(self.s + other.s, self.a + other.a)

    #--- subtraction
    @always_inline # Hybrid - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.a)
    
    @always_inline # Hybrid - Hybrid
    fn __sub__[__:None=None](self, other: Self) -> Self:
        return Self(self.s - other.s, self.a - other.a)

    #--- multiplication
    @always_inline # Hybrid * Scalar
    fn __mul__(self, other: Self.Coef) -> Self:
        return Self(self.s*other, self.a*other)

    @always_inline # Hybrid * Hybrid
    fn __mul__[__:None=None](self, other: Self) -> Self:
        return Self(self.s*other.s + square*self.a*other.a, self.s*other.a + self.a*other.s)

    #--- division
    @always_inline # Hybrid / Scalar
    fn __truediv__(self, other: Self.Coef) -> Self:
        return self * (1/other)

    @always_inline # Hybrid / Hybrid
    fn __truediv__[__:None=None](self, other: Self) -> Self:
        return self*other.conjugate() / other.denomer()

    @always_inline # Hybrid // Scalar
    fn __floordiv__(self, other: Self.Coef) -> Self:
        return Self(self.s // other, self.a // other)

    @always_inline # Hybrid // Hybrid
    fn __floordiv__[__:None=None](self, other: Self) -> Self:
        return self*other.conjugate() // other.denomer()

    #--- exponentiation
    @always_inline # Hybrid ** Scalar
    fn __pow__(self, other: Self.Coef) -> Self:
        return pow(self, other)

    @always_inline # Hybrid ** Hybrid
    fn __pow__(self, other: Self) -> Self:
        return pow(self, other)
    
    
    #------( Reverse Arithmetic )------#
    #
    #--- addition
    @always_inline # Scalar + Hybrid
    fn __radd__(self, other: Self.Coef) -> Self:
        return Self(other + self.s, self.a)

    @always_inline # Hybrid + Hybrid
    fn __radd__[__:None=None](self, other: Self) -> Self:
        return other + self

    #--- subtraction
    @always_inline # Scalar - Hybrid
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.s, -self.a)

    @always_inline # Hybrid - Hybrid
    fn __rsub__[__:None=None](self, other: Self) -> Self:
        return other - self

    #--- multiplication
    @always_inline # Scalar * Hybrid
    fn __rmul__(self, other: Self.Coef) -> Self:
        return Self(other * self.s, other * self.a)

    @always_inline # Hybrid * Hybrid
    fn __rmul__[__:None=None](self, other: Self) -> Self:
        return other * self

    #--- division
    @always_inline # Scalar / Hybrid
    fn __rtruediv__(self, other: Self.Coef) -> Self:
        return other*self.conjugate() / self.denomer()

    @always_inline # Hybrid / Hybrid
    fn __rtruediv__[__:None=None](self, other: Self) -> Self:
        return other / self

    @always_inline # Scalar // Hybrid
    fn __rfloordiv__(self, other: Self.Coef) -> Self:
        return other*self.conjugate() // self.denomer()

    @always_inline # Hybrid // Hybrid
    fn __rfloordiv__[__:None=None](self, other: Self) -> Self:
        return other // self

    #--- exponentiation
    @always_inline # Scalar ** Hybrid
    fn __rpow__(self, other: Self.Coef) -> Self:
        return pow(other, self)

    @always_inline # Hybrid ** Hybrid
    fn __rpow__(self, other: Self) -> Self:
        return pow(other, self)
    
    
    #------( In Place Arithmetic )------#
    #
    #--- addition
    @always_inline # Hybrid += Scalar
    fn __iadd__(inout self, other: Self.Coef):
        self = self + other
    
    @always_inline # Hybrid += Hybrid
    fn __iadd__[__:None=None](inout self, other: Self):
        self = self + other

    #--- subtraction
    @always_inline # Hybrid -= Scalar
    fn __isub__(inout self, other: Self.Coef):
        self = self - other
    
    @always_inline # Hybrid -= Hybrid
    fn __isub__[__:None=None](inout self, other: Self):
        self = self - other

    #--- multiplication
    @always_inline # Hybrid *= Scalar
    fn __imul__(inout self, other: Self.Coef):
        self = self * other

    @always_inline # Hybrid *= Hybrid
    fn __imul__[__:None=None](inout self, other: Self):
        self = self * other

    #--- division
    @always_inline # Hybrid /= Scalar
    fn __itruediv__(inout self, other: Self.Coef):
        self = self / other

    @always_inline # Hybrid /= Hybrid
    fn __itruediv__[__:None=None](inout self, other: Self):
        self = self / other

    @always_inline # Hybrid //= Scalar
    fn __ifloordiv__(inout self, other: Self.Coef):
        self = self // other

    @always_inline # Hybrid //= Hybrid
    fn __ifloordiv__[__:None=None](inout self, other: Self):
        self = self // other

    #--- exponentiation
    @always_inline # Hybrid **= Scalar
    fn __ipow__(inout self, other: Self.Coef):
        self = self ** other

    @always_inline # Hybrid **= Hybrid
    fn __ipow__[__:None=None](inout self, other: Self):
        self = self ** other