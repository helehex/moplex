# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Implements a hybrid type backed by SIMD vectors."""


# +----------------------------------------------------------------------------------------------+ #
# | Hybrid Alias
# +----------------------------------------------------------------------------------------------+ #
#
alias HybridInt8 = HybridSIMD[DType.int8, 1, _]
alias HybridUInt8 = HybridSIMD[DType.uint8, 1, _]
alias HybridInt16 = HybridSIMD[DType.int16, 1, _]
alias HybridUInt16 = HybridSIMD[DType.uint16, 1, _]
alias HybridInt32 = HybridSIMD[DType.int32, 1, _]
alias HybridUInt32 = HybridSIMD[DType.uint32, 1, _]
alias HybridInt64 = HybridSIMD[DType.int64, 1, _]
alias HybridUInt64 = HybridSIMD[DType.uint64, 1, _]
alias Hybrid16 = HybridSIMD[DType.float16, 1, _]
alias Hybrid32 = HybridSIMD[DType.float32, 1, _]
alias Hybrid64 = HybridSIMD[DType.float64, 1, _]


# +----------------------------------------------------------------------------------------------+ #
# | Complex Alias
# +----------------------------------------------------------------------------------------------+ #
#
alias ComplexInt8 = HybridInt8[-1]
alias ComplexUInt8 = HybridUInt8[-1]
alias ComplexInt16 = HybridInt16[-1]
alias ComplexUInt16 = HybridUInt16[-1]
alias ComplexInt32 = HybridInt32[-1]
alias ComplexUInt32 = HybridUInt32[-1]
alias ComplexInt64 = HybridInt64[-1]
alias ComplexUInt64 = HybridUInt64[-1]
alias Complex16 = Hybrid16[-1]
alias Complex32 = Hybrid32[-1]
alias Complex64 = Hybrid64[-1]


# +----------------------------------------------------------------------------------------------+ #
# | Dualplex Alias
# +----------------------------------------------------------------------------------------------+ #
#
alias DualplexInt8 = HybridInt8[0]
alias DualplexUInt8 = HybridUInt8[0]
alias DualplexInt16 = HybridInt16[0]
alias DualplexUInt16 = HybridUInt16[0]
alias DualplexInt32 = HybridInt32[0]
alias DualplexUInt32 = HybridUInt32[0]
alias DualplexInt64 = HybridInt64[0]
alias DualplexUInt64 = HybridUInt64[0]
alias Dualplex16 = Hybrid16[0]
alias Dualplex32 = Hybrid32[0]
alias Dualplex64 = Hybrid64[0]


# +----------------------------------------------------------------------------------------------+ #
# | Hyperplex Alias
# +----------------------------------------------------------------------------------------------+ #
#
alias HyperplexInt8 = HybridInt8[1]
alias HyperplexUInt8 = HybridUInt8[1]
alias HyperplexInt16 = HybridInt16[1]
alias HyperplexUInt16 = HybridUInt16[1]
alias HyperplexInt32 = HybridInt32[1]
alias HyperplexUInt32 = HybridUInt32[1]
alias HyperplexInt64 = HybridInt64[1]
alias HyperplexUInt64 = HybridUInt64[1]
alias Hyperplex16 = Hybrid16[1]
alias Hyperplex32 = Hybrid32[1]
alias Hyperplex64 = Hybrid64[1]


# +----------------------------------------------------------------------------------------------+ #
# | Hybrid SIMD
# +----------------------------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct HybridSIMD[type: DType, size: Int, square: FloatLiteral](
    StringableCollectionElement, Formattable, EqualityComparable
):
    """
    Represents a hybrid small vector backed by hardware vector elements, with scalar and antiox parts.

    Coefficients take precedence as the major axis istead of the SIMD axis.

    SIMD allows a single instruction to be executed across the multiple data elements of the vector.

    Parameterized on the antiox squared.

        square = antiox*antiox

    Parameters:
        type: The data type of HybridSIMD vector elements.
        size: The size of the HybridSIMD vector.
        square: The value of the antiox unit squared.
    """

    # +------[ Alias ]------+ #
    #
    alias Coef = SIMD[type, size]
    """Represents a SIMD coefficient."""

    alias Lane = HybridSIMD[type, 1, square]
    """Represents a single hybrid element."""

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
        """Initializes a HybridSIMD from coefficients."""
        self.re = re
        self.im = im

    @always_inline  # Coefficients
    fn __init__[__: None = None](inout self, re: SIMD[type, 1] = 0, im: SIMD[type, 1] = 0):
        """Initializes a HybridSIMD from coefficients."""
        self.re = re
        self.im = im

    @always_inline  # Coefficients
    fn __init__(inout self, t: (Int, Int)):
        """Initializes a HybridSIMD from coefficients."""
        self.re = t.get[0, Int]()
        self.im = t.get[1, Int]()

    @always_inline  # Coefficients
    fn __init__(inout self, t: (FloatLiteral, FloatLiteral)):
        """Initializes a HybridSIMD from coefficients."""
        self.re = t.get[0, FloatLiteral]()
        self.im = t.get[1, FloatLiteral]()

    @always_inline  # Coefficients
    fn __init__(inout self, t: (Scalar[type], Scalar[type])):
        """Initializes a HybridSIMD from coefficients."""
        self.re = t.get[0, Scalar[type]]()
        self.im = t.get[1, Scalar[type]]()

    @always_inline  # Scalar
    fn __init__(inout self, re: IntLiteral):
        """Initializes a HybridSIMD from a IntLiteral."""
        self.re = re
        self.im = 0

    @always_inline  # Scalar
    fn __init__[__: None = None](inout self, re: FloatLiteral):
        """Initializes a HybridSIMD from a FloatLiteral. Truncates if necessary."""
        self.re = re
        self.im = 0

    @always_inline  # Scalar
    fn __init__(inout self, re: Int):
        """Initializes a HybridSIMD from an Int."""
        self.re = re
        self.im = 0

    @always_inline  # Hybrid
    fn __init__(inout self, *h: Self.Lane):
        """Initializes a HybridSIMD from a variadic argument of hybrid elements."""
        var result = Self(h[0].re, h[0].im)
        for i in range(len(h)):
            result.setlane(i, h[i])
        self = result

    @always_inline  # Hybrid
    fn __init__(inout self, h: HybridIntLiteral[square]):
        """Initializes a HybridSIMD from a HybridIntLiteral."""
        self.re = h.re
        self.im = h.im

    @always_inline  # Hybrid
    fn __init__(inout self, h: HybridFloatLiteral[square]):
        """Initializes a HybridSIMD from a HybridFloatLiteral."""
        self.re = h.re
        self.im = h.im

    @always_inline  # Hybrid
    fn __init__(inout self, h: HybridInt[square]):
        """Initializes a HybridSIMD from a HybridInt."""
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
        return (self.re == 0 and self.im == 0).__bool__()

    @always_inline
    fn is_null(self) -> Bool:
        """Returns true when this hybrid number has a measure of zero."""
        return (contrast(self) == 0).__bool__()

    @always_inline
    fn __hybrid_int__(self) -> HybridInt[square]:
        """Casts the value to a HybridInt. Any fractional components are truncated towards zero."""
        return HybridInt[square](int(self.re), int(self.im))

    @always_inline
    fn to_tuple(self) -> (Self.Coef, Self.Coef):
        """Creates a non-algebraic Tuple from the hybrids parts."""
        return (self.re, self.im)

    @always_inline
    fn unitize(self) -> HybridSIMD[type, size, Self.unital_square]:
        """Unitize the HybridSIMD. Normalizes the square and adjusts the antiox coefficient."""
        return HybridSIMD[type, size, Self.unital_square](self.re, self.im * Self.unital_factor)

    @always_inline
    fn unitize[target_square: FloatLiteral](self) -> HybridSIMD[type, size, target_square]:
        """Unitize the HybridSIMD. Sets the square and adjusts the antiox coefficient."""
        constrained[
            sign(square) == sign(target_square),
            "cannot unitize: the squares signs must match",
        ]()
        alias factor = ufac(square) / ufac(target_square)
        return HybridSIMD[type, size, target_square](self.re, self.im * factor)

    @always_inline
    fn cast[target_type: DType](self) -> HybridSIMD[target_type, size, square]:
        """Casts the HybridSIMD to the target DType."""
        return HybridSIMD[target_type, size, square](
            self.re.cast[target_type](), self.im.cast[target_type]()
        )

    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        """Formats the hybrid as a String."""
        return String.format_sequence(self)

    @no_inline
    fn format_to(self, inout writer: Formatter):
        """Formats the hybrid as a String."""

        @parameter
        if size == 1:
            writer.write(self.re, " + ", self.im, symbol[square]())
        else:

            @parameter
            for lane in range(size - 1):
                self.getlane(lane).format_to(writer)
                writer.write("\n")
            self.getlane(size - 1).format_to(writer)

    # +------( Subscript )------+ #
    #
    @always_inline
    fn __getattr__[key: StringLiteral](self) -> Self.Coef:
        return self.get_antiox[antiox(key)]()

    @always_inline
    fn __setattr__[key: StringLiteral](inout self, val: Self.Coef):
        self.set_antiox[antiox(key)](val)

    @always_inline
    fn __getitem__(self, idx: Int) -> Self.Lane:
        return self.getlane(idx)

    @always_inline
    fn __setitem__(inout self, idx: Int, coef: Self.Lane):
        self.setlane(idx, coef)

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
    fn getlane(self, idx: Int) -> Self.Lane:
        """
        Gets a hybrid element from the SIMD vector axis.

        Args:
            idx: The index of the hybrid element.

        Returns:
            The hybrid element at position `idx`.
        """
        return Self.Lane(self.re[idx], self.im[idx])

    @always_inline
    fn setlane(inout self, idx: Int, item: Self.Lane):
        """
        Sets a hybrid element in the SIMD vector axis.

        Args:
            idx: The index of the hybrid element.
            item: The hybrid element to insert at position `idx`.
        """
        self.re[idx] = item.re
        self.im[idx] = item.im

    @always_inline
    fn get_antiox[_square: FloatLiteral](self) -> Self.Coef:
        constrained[
            sign(square) == sign(_square),
            "cannot get antiox: the squares signs must match",
        ]()
        return self.im * (Self.unital_factor / ufac(_square))

    @always_inline
    fn set_antiox[_square: FloatLiteral](inout self, antiox: Self.Coef):
        constrained[
            sign(square) == sign(_square),
            "cannot set antiox: the squares signs must match",
        ]()
        self.im = antiox * (ufac(_square) / Self.unital_factor)

    # +------( Min / Max )------+ #
    #
    @always_inline
    fn min(self, other: Self) -> Self:
        """Return the value which is closest to negative infinity."""
        var cond = (self < other) | (isnan_hybrid(self))
        return simd_select(cond, self, other)

    @always_inline
    fn min_coef(self) -> Self.Coef:
        """Returns the coefficient which is closest to negative infinity."""
        return min(self.re, self.im)

    @always_inline
    fn reduce_min(self) -> Self.Lane:
        """Returns the hybrid element with the smallest measure across the SIMD axis. Remind me to improve implementation.
        """

        @parameter
        fn _min(a: HybridSIMD, b: __type_of(a)) -> __type_of(a):
            return a.min(b)

        return self.reduce[_min]()

    @always_inline
    fn reduce_min_coef(self) -> SIMD[type, 1]:
        """Returns the smallest value across both the SIMD and Hybrid axis."""
        return min(self.re.reduce_min(), self.im.reduce_min())

    @always_inline
    fn reduce_min_compose(self) -> Self.Lane:
        """Returns the hybrid vector element which is the composition of the smallest scalar and the smallest antiox across the SIMD axis.
        """
        return Self.Lane(self.re.reduce_min(), self.im.reduce_min())

    # +--- Max
    @always_inline
    fn max(self, other: Self) -> Self:
        """Return the value which is closest to positive infinity."""
        var cond = (self > other) | (isnan_hybrid(self))
        return simd_select(cond, self, other)

    @always_inline
    fn max_coef(self) -> Self.Coef:
        """Returns the coefficient which is closest to positive infinity."""
        return max(self.re, self.im)

    @always_inline
    fn reduce_max(self) -> Self.Lane:
        """Returns the hybrid element with the largest measure across the SIMD axis. Remind me to improve implementation.
        """

        @parameter
        fn _max(a: HybridSIMD, b: __type_of(a)) -> __type_of(a):
            return a.max(b)

        return self.reduce[_max]()

    @always_inline
    fn reduce_max_coef(self) -> SIMD[type, 1]:
        """Returns the largest value across both the SIMD and Hybrid axis."""
        return max(self.re.reduce_max(), self.im.reduce_max())

    @always_inline
    fn reduce_max_compose(self) -> Self.Lane:
        """Returns the hybrid vector element which is the composition of the largest scalar and the largest antiox across the SIMD axis.
        """
        return Self.Lane(self.re.reduce_max(), self.im.reduce_max())

    # +------( SIMD Vector )------+ #
    #
    @always_inline
    fn __len__(self) -> Int:
        """Returns the length of the SIMD axis. Guaranteed to be a power of 2."""
        return size

    @always_inline
    fn fma(self, mul: Self.Coef, acc: Self.Coef) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type, size, square](self.re.fma(mul, acc), self.im * mul)

    @always_inline
    fn fma[__: None = None](self, mul: Self, acc: Self.Coef) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type, size, square](
            self.re.fma(mul.re, self.im.fma(square * mul.im, acc)),
            self.re.fma(mul.im, self.im * mul.re),
        )

    @always_inline
    fn fma[__: None = None](self, mul: Self.Coef, acc: Self) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type, size, square](self.re.fma(mul, acc.re), self.im.fma(mul, acc.im))

    @always_inline
    fn fma[__: None = None, ___: None = None](self, mul: Self, acc: Self) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type, size, square](
            self.re.fma(mul.re, self.im.fma(square * mul.im, acc.re)),
            self.re.fma(mul.im, self.im.fma(mul.re, acc.im)),
        )

    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        """Shuffle elements along the SIMD axis using a permutation mask."""
        return Self(
            self.re._shuffle_list[mask](self.re),
            self.im._shuffle_list[mask](self.im),
        )

    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        """Shuffle elements along the SIMD axis using a permutation mask and add to other."""
        return Self(
            self.re._shuffle_list[mask](other.re),
            self.im._shuffle_list[mask](other.im),
        )

    @always_inline
    fn slice[slice_size: Int, offset: Int](self) -> HybridSIMD[type, slice_size, square]:
        """Returns a slice of the HybridSIMD vector with the specified size at a given offset."""
        return HybridSIMD[type, slice_size, square](
            self.re.slice[slice_size, offset=offset](),
            self.im.slice[slice_size, offset=offset](),
        )

    @always_inline
    fn join(self, other: Self) -> HybridSIMD[type, 2 * size, square]:
        """Concatenates the two HybridSIMD vectors together."""
        return HybridSIMD[type, 2 * size, square](self.re.join(other.re), self.im.join(other.im))

    @always_inline
    fn interleave(self, other: Self) -> HybridSIMD[type, 2 * size, square]:
        """Returns a HybridSIMD vector that alternates between the two inputs."""
        return HybridSIMD[type, 2 * size, square](
            self.re.interleave(other.re), self.im.interleave(other.im)
        )

    @always_inline
    fn deinterleave(
        self,
    ) -> (HybridSIMD[type, size // 2, square], HybridSIMD[type, size // 2, square],):
        """Deinterleaves this HybridSIMD vector into even and odd indicies."""
        var re = self.re.deinterleave()
        var im = self.im.deinterleave()
        return (
            HybridSIMD[type, size // 2, square](re[0], im[0]),
            HybridSIMD[type, size // 2, square](re[1], im[1]),
        )

    @always_inline
    fn reduce[
        func: fn (a: HybridSIMD, b: __type_of(a)) capturing -> __type_of(a),
        size_out: Int = 1,
    ](self) -> HybridSIMD[type, size_out, square]:
        """Calls func recursively on this HybridSIMD to reduce it to the specified size."""

        @parameter
        if size_out >= size:
            return self.slice[size_out, 0]()
        else:
            var reduced = self.reduce[func, 2 * size_out]()
            return func(
                reduced.slice[size_out, 0](),
                reduced.slice[size_out, size_out](),
            )

    @always_inline
    fn reduce_add(self) -> Self.Lane:
        """Returns the sum of all Hybrid elements accross the SIMD axis."""

        @parameter
        fn _add(a: HybridSIMD, b: __type_of(a)) -> __type_of(a):
            return a + b

        return self.reduce[_add]()

    @always_inline
    fn reduce_mul(self) -> Self.Lane:
        """Returns the product of all Hybrid elements accross the SIMD axis."""

        @parameter
        fn _mul(a: HybridSIMD, b: __type_of(a)) -> __type_of(a):
            return a * b

        return self.reduce[_mul]()

    @always_inline
    fn rotate_left[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount (with wrap).
        """
        return Self(self.re.rotate_left[shift](), self.im.rotate_left[shift]())

    @always_inline
    fn rotate_right[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount (with wrap).
        """
        return Self(self.re.rotate_right[shift](), self.im.rotate_right[shift]())

    @always_inline
    fn shift_left[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount."""
        return Self(self.re.shift_left[shift](), self.im.shift_left[shift]())

    @always_inline
    fn shift_right[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount."""
        return Self(self.re.shift_right[shift](), self.im.shift_right[shift]())

    # +------( Comparison )------+ #
    #
    @always_inline
    fn __lt__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's.
        """
        return contrast(self) < contrast[square](other)

    @always_inline
    fn __lt__[__: None = None](self, other: Self) -> SIMD[DType.bool, size]:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's.
        """
        return contrast(self) < contrast(other)

    @always_inline
    fn __le__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's.
        """
        return contrast(self) <= contrast[square](other)

    @always_inline
    fn __le__[__: None = None](self, other: Self) -> SIMD[DType.bool, size]:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's.
        """
        return contrast(self) <= contrast(other)

    @always_inline
    fn __eq__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return (self.re == other) & (self.im == 0)

    @always_inline
    fn __eq__[____: None = None](self, other: Self) -> SIMD[DType.bool, size]:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return (self.re == other.re) & (self.im == other.im)

    @always_inline
    fn __eq__[__: None = None, ___: None = None](self, other: Self) -> Bool:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return (self.__eq__[____=None](other)).reduce_and()

    @always_inline
    fn __ne__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal.
        """
        return (self.re != other) | (self.im != 0)

    @always_inline
    fn __ne__[____: None = None](self, other: Self) -> SIMD[DType.bool, size]:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal.
        """
        return (self.re != other.re) | (self.im != other.im)

    @always_inline
    fn __ne__[__: None = None, ___: None = None](self, other: Self) -> Bool:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal.
        """
        return (self.__ne__[____=None](other)).reduce_or()

    @always_inline
    fn __gt__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's.
        """
        return contrast(self) > contrast[square](other)

    @always_inline
    fn __gt__[__: None = None](self, other: Self) -> SIMD[DType.bool, size]:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's.
        """
        return contrast(self) > contrast(other)

    @always_inline
    fn __ge__(self, other: Self.Coef) -> SIMD[DType.bool, size]:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's.
        """
        return contrast(self) >= contrast[square](other)

    @always_inline
    fn __ge__[__: None = None](self, other: Self) -> SIMD[DType.bool, size]:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's.
        """
        return contrast(self) >= contrast(other)

    # +------( Unary )------+ #
    #
    @always_inline
    fn __neg__(self) -> Self:
        """Defines the unary `-` negative operator. Returns the negative of this hybrid number."""
        return Self(-self.re, -self.im)

    # @always_inline
    # fn __abs__(self) -> Self:
    #     """Defines the absolute value of a hybrid number."""
    #     return

    @always_inline
    fn __invert__(self) -> Self:
        """
        Defines the unary `~` invert operator. Performs bit-wise invert.

        SIMD type must be integral (or boolean).

        Returns:
            The bit-wise inverted hybrid number.
        """
        return Self(
            ~self.re, ~self.im
        )  # could define different behaviour. bit invert is not used very often with complex types.

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
            Complex   -> [0]*[0] + [1]*[1]
            Dualplex  -> [0]*[0]
            Hyperplex -> [0]*[0] - [1]*[1]

        Parameters:
            absolute: Setting this true will ensure a positive result.

        Returns:
            The hybrid denomer.
        """

        @parameter
        if absolute:
            return abs(self.inner(self))
        else:
            return self.inner(self)

    @always_inline
    fn measure[absolute: Bool = False](self) -> Self.Coef:
        """
        Gets the measure of this hybrid number.

        This is similar to magnitude, but is not guaranteed to be positive when the antiox squared is positive.

        Equal to the square root of the denomer.

        Parameters:
            absolute: Setting this true will ensure a definite result.

        Returns:
            The hybrid measure.
        """

        @parameter
        if square == 0:
            return abs(self.re)
        else:
            return sqrt(self.denomer[absolute]())

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
            return log(self.measure())
        else:
            return log(self.denomer[absolute]()) / 2

    # # figure our how to best rectify imaginary modulus from hyperplex numbers
    # @always_inline
    # fn modulus(self) -> HybridSIMD[type,size,-1]:
    #     """
    #     Get the modulus of this hybrid number.

    #     This is similar to the magnitude of a hybrid number, but returns a complex number to handle special cases.
    #     """
    #     @parameter
    #     if square != 0: return sqrt(HybridSIMD[type,size,-1](self.denomer[False]()))
    #     return abs(self.re)

    @always_inline
    fn argument[branch: IntLiteral = 0](self) -> Self.Coef:
        """Gets the argument of this hybrid number."""

        @parameter
        if square == -1:
            return atan(self.im / self.re) + branch * pi
        elif square == 0:
            return self.im / self.re
        elif square == 1:
            return atanh(self.im / self.re)
        else:
            return self.unitize().argument() / Self.unital_factor

    # @always_inline
    # fn argument2[branch: Int = 0](self) -> Float64:
    #     """Gets the argument of this hybrid number. *Work in progress, may change."""
    #     @parameter
    #     if square == -1:
    #         return atan2(self.im, self.re) + branch*pi
    #     elif square == 0:
    #         return self.im/self.re
    #     elif square == 1:
    #         return log(abs(self.re + self.im) / self.measure[True]())
    #     else:
    #         return self.unitize().argument() / Self.unital_factor

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

            (h1.conjugate()*h2).re

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

            (h1.conjugate()*h2).im

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

    @always_inline  # Hybrid + Hybrid
    fn __add__[
        __: None = None
    ](self, other: HybridSIMD[type, size, _]) -> MultiplexSIMD[type, size]:
        return MultiplexSIMD(self) + other

    # +--- subtraction
    @always_inline  # Hybrid - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.re - other, self.im)

    @always_inline  # Hybrid - Hybrid
    fn __sub__[__: None = None](self, other: Self) -> Self:
        return Self(self.re - other.re, self.im - other.im)

    @always_inline  # Hybrid - Hybrid
    fn __sub__[
        __: None = None
    ](self, other: HybridSIMD[type, size, _]) -> MultiplexSIMD[type, size]:
        return MultiplexSIMD(self) - other

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
        return (self * other.conjugate()) / other.denomer()

    @always_inline  # Hybrid // Scalar
    fn __floordiv__(self, other: Self.Coef) -> Self:
        return Self(self.re // other, self.im // other)

    @always_inline  # Hybrid // Hybrid
    fn __floordiv__[__: None = None](self, other: Self) -> Self:
        return (self * other.conjugate()) // other.denomer()

    # +--- exponentiation
    @always_inline  # Hybrid ** Scalar
    fn __pow__(self, other: Self.Coef) -> Self:
        if other == 1:
            return self
        elif other == 2:
            return self * self
        elif other == 3:
            return self * self * self
        else:

            @parameter
            if square == 0:
                return pow(self.re, other - 1) * HybridSIMD[type, size, square](
                    self.re, self.im * other
                )
            else:
                return exp(other * log(self))

    @always_inline  # Hybrid ** Hybrid
    fn __pow__[__: None = None, branch: IntLiteral = 0](self, other: Self) -> Self:
        if other == 1:
            return self
        elif other == 2:
            return self * self
        elif other == 3:
            return self * self * self
        else:

            @parameter
            if square == 0:
                return pow(self.re, other.re - 1) * HybridSIMD[type, size, square](
                    self.re,
                    other.im * self.re * log(self.re) + self.im * other.re,
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

    @always_inline  # Hybrid + Hybrid
    fn __radd__[
        __: None = None
    ](self, other: HybridSIMD[type, size, _]) -> MultiplexSIMD[type, size]:
        return other + self

    # +--- subtraction
    @always_inline  # Scalar - Hybrid
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.re, -self.im)

    @always_inline  # Hybrid - Hybrid
    fn __rsub__[__: None = None](self, other: Self) -> Self:
        return other - self

    @always_inline  # Hybrid - Hybrid
    fn __rsub__[
        __: None = None
    ](self, other: HybridSIMD[type, size, _]) -> MultiplexSIMD[type, size]:
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
    fn __rfloordiv__(self, other: Self.Coef) -> Self:
        return other * self.conjugate() // self.denomer()

    @always_inline  # Hybrid // Hybrid
    fn __rfloordiv__[__: None = None](self, other: Self) -> Self:
        return other // self

    # +--- exponentiation
    @always_inline  # Scalar ** Hybrid
    fn __rpow__(self, other: Self.Coef) -> Self:
        return exp(self * log(other))

    @always_inline  # Hybrid ** Hybrid
    fn __rpow__[__: None = None](self, other: Self) -> Self:
        return pow(other, self)

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
    @always_inline  # Hybrid **= Scalar
    fn __ipow__(inout self, other: Self.Coef):
        self = self**other

    @always_inline  # Hybrid **= Hybrid
    fn __ipow__[__: None = None](inout self, other: Self):
        self = self**other
