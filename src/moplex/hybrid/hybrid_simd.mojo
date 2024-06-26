"""
Implements hybrid types backed by SIMD vectors. Parameterized on the antiox squared.
"""

alias ComplexInt8   = HybridSIMD[DType.int8,1,-1]
alias ComplexUInt8  = HybridSIMD[DType.uint8,1,-1]
alias ComplexInt16  = HybridSIMD[DType.int16,1,-1]
alias ComplexUInt16 = HybridSIMD[DType.uint16,1,-1]
alias ComplexInt32  = HybridSIMD[DType.int32,1,-1]
alias ComplexUInt32 = HybridSIMD[DType.uint32,1,-1]
alias ComplexInt64  = HybridSIMD[DType.int64,1,-1]
alias ComplexUInt64 = HybridSIMD[DType.uint64,1,-1]
alias Complex16     = HybridSIMD[DType.float16,1,-1]
alias Complex32     = HybridSIMD[DType.float32,1,-1]
alias Complex64     = HybridSIMD[DType.float64,1,-1]
alias Complex       = HybridSIMD[_, 1, -1]

alias ParaplexInt8   = HybridSIMD[DType.int8,1,0]
alias ParaplexUInt8  = HybridSIMD[DType.uint8,1,0]
alias ParaplexInt16  = HybridSIMD[DType.int16,1,0]
alias ParaplexUInt16 = HybridSIMD[DType.uint16,1,0]
alias ParaplexInt32  = HybridSIMD[DType.int32,1,0]
alias ParaplexUInt32 = HybridSIMD[DType.uint32,1,0]
alias ParaplexInt64  = HybridSIMD[DType.int64,1,0]
alias ParaplexUInt64 = HybridSIMD[DType.uint64,1,0]
alias Paraplex16     = HybridSIMD[DType.float16,1,0]
alias Paraplex32     = HybridSIMD[DType.float32,1,0]
alias Paraplex64     = HybridSIMD[DType.float64,1,0]
alias Paraplex       = HybridSIMD[_, 1, 0]

alias HyperplexInt8   = HybridSIMD[DType.int8,1,1]
alias HyperplexUInt8  = HybridSIMD[DType.uint8,1,1]
alias HyperplexInt16  = HybridSIMD[DType.int16,1,1]
alias HyperplexUInt16 = HybridSIMD[DType.uint16,1,1]
alias HyperplexInt32  = HybridSIMD[DType.int32,1,1]
alias HyperplexUInt32 = HybridSIMD[DType.uint32,1,1]
alias HyperplexInt64  = HybridSIMD[DType.int64,1,1]
alias HyperplexUInt64 = HybridSIMD[DType.uint64,1,1]
alias Hyperplex16     = HybridSIMD[DType.float16,1,1]
alias Hyperplex32     = HybridSIMD[DType.float32,1,1]
alias Hyperplex64     = HybridSIMD[DType.float64,1,1]
alias Hyperplex       = HybridSIMD[_, 1, 0]

alias HybridFloat64     = HybridSIMD[DType.float64, 1]

fn _constrain_square[type: DType, a: SIMD[type,1], b: FloatLiteral](): constrained[a == b, "mismatched 'square' parameter"]()
fn _constrain_square[type: DType, a: SIMD[type,1], b: Float64](): constrained[a == b, "mismatched 'square' parameter"]()

@always_inline
fn _ufac[type: DType, size: Int, square: SIMD[type,size]]() -> SIMD[type,size]:
    @parameter
    if square == sign[type,size,square](): return 1
    else: return sqrt[type, size, abs[type, size, square]()]()





#------------ Hybrid SIMD ------------#
#---
#---
@register_passable("trivial")
struct HybridSIMD[type: DType, size: Int, square: FloatLiteral](Stringable, CollectionElement):
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


    #------[ Alias ]------#
    #
    alias Type = HybridSIMD[type,size,square]
    """Self."""

    alias Coef = SIMD[type,size]
    """Represents a SIMD coefficient."""

    alias Lane = HybridSIMD[type,1,square]
    """Represents a single SIMD vector element."""

    alias unital_square: FloatLiteral = sign(square)
    """The normalized square."""

    alias unital_factor: FloatLiteral = ufac(square)
    """The unitization factor."""


    

    #------< Data >------#
    #
    var s: Self.Coef # real
    """The scalar part."""

    var a: Self.Coef # anti
    """The antiox part."""
    
    
    #------( Initialize )------#
    #
    @always_inline # Coefficients
    fn __init__(s: Self.Coef = 0, a: Self.Coef = 0) -> Self:
        """Initializes a HybridSIMD from coefficients."""
        return Self{s:s, a:a}

    @always_inline # Coefficients
    fn __init__[__:None=None](s: SIMD[type,1] = 0, a: SIMD[type,1] = 0) -> Self:
        """Initializes a HybridSIMD from coefficients."""
        return Self{s:s, a:a}

    @always_inline # Coefficients
    fn __init__(t: Tuple[Int, Int]) -> Self:
        """Initializes a HybridSIMD from coefficients."""
        return Self{s:t.get[0, Int](), a:t.get[1, Int]()}

    @always_inline # Coefficients
    fn __init__(t: Tuple[FloatLiteral, FloatLiteral]) -> Self:
        """Initializes a HybridSIMD from coefficients."""
        return Self{s:t.get[0, FloatLiteral](), a:t.get[1, FloatLiteral]()}

    @always_inline # Coefficients
    fn __init__(t: Tuple[Scalar[type], Scalar[type]]) -> Self:
        """Initializes a HybridSIMD from coefficients."""
        return Self{s:t.get[0, Scalar[type]](), a:t.get[1, Scalar[type]]()}

    @always_inline # Scalar
    fn __init__(s: FloatLiteral) -> Self:
        """Initializes a HybridSIMD from a FloatLiteral. Truncates if necessary."""
        return Self{s:s, a:0}

    @always_inline # Scalar
    fn __init__(s: Int) -> Self:
        """Initializes a HybridSIMD from an Int."""
        return Self{s:s, a:0}

    @always_inline # Hybrid
    fn __init__(*h: HybridSIMD[type, 1, square]) -> Self:
        """Initializes a HybridSIMD from a variadic argument of hybrid elements."""
        var result: Self = Self{s:h[0].s, a:h[0].a}
        for i in range(len(h)):
            result.set_hybrid(i, h[i])
        return result

    @always_inline # Hybrid
    fn __init__(h: HybridIntLiteral) -> Self:
        """Initializes a HybridSIMD from a HybridIntLiteral."""
        _constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}

    @always_inline # Hybrid
    fn __init__(h: HybridFloatLiteral) -> Self:
        """Initializes a HybridSIMD from a HybridFloatLiteral."""
        _constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}

    @always_inline # Hybrid
    fn __init__(h: HybridInt) -> Self:
        """Initializes a HybridSIMD from a HybridInt."""
        _constrain_square[type, square, h.square]()
        return Self{s:h.s, a:h.a}


    #------( Cast )------#
    #
    @always_inline
    fn __bool__(self) -> Bool:
        """Returns true when this hybrid number has a non zero measure."""
        return not self.is_nil()

    @always_inline
    fn is_zero(self) -> Bool:
        """Returns true when both parts of this hybrid number are zero."""
        return self.s == 0 and self.a == 0

    @always_inline
    fn is_nil(self) -> Bool:
        """Returns true when this hybrid number has a non zero measure."""
        return self.contrast() == 0

    @always_inline
    fn __hybrid_int__(self) -> HybridInt[square]:
        """Casts the value to a HybridInt. Any fractional components are truncated towards zero."""
        return HybridInt[square](int(self.s), int(self.a))

    @always_inline
    fn to_tuple(self) -> StaticTuple[Self.Coef, 2]:
        """Creates a non-algebraic StaticTuple from the hybrids parts."""
        return StaticTuple[Self.Coef, 2](self.s, self.a)

    @always_inline
    fn to_unital(self) -> HybridSIMD[type, size, Self.unital_square]:
        """Unitize the HybridSIMD, this normalizes the square and adjusts the antiox coefficient."""
        return HybridSIMD[type, size, Self.unital_square](self.s, self.a * Self.unital_factor)

    @always_inline
    fn cast[target_type: DType = type, target_square: FloatLiteral = square](self) -> HybridSIMD[target_type, size, target_square]:
        """Casts the elements of the HybridSIMD to the target type and square type."""
        alias Target = HybridSIMD[target_type,size,target_square]
        alias factor = Self.unital_factor / Target.unital_factor
        constrained[Self.unital_square == Target.unital_square, "cannot cast to target square"]()
        return Target(self.s.cast[target_type](), self.a.cast[target_type]() * factor)
    
    @always_inline
    fn try_cast[
        target_type: DType = type,
        target_square: FloatLiteral = square,
        fail: HybridSIMD[target_type, 1, target_square] = nan_hybrid[target_type, target_square, 1, HybridSIMD[target_type, 1, target_square](0)]()
        ](self, inout result: HybridSIMD[target_type, size, target_square]) -> Bool:
        """Casts the elements of the HybridSIMD to the target type and square type."""

        alias Target = HybridSIMD[target_type,size,target_square]
        alias factor = Self.unital_factor / Target.unital_factor
        
        @parameter
        if Self.unital_square != Target.unital_square:
            result = fail
            return False
        else:
            result = Target(self.s.cast[target_type](), self.a.cast[target_type]() * factor)
            return True
    
    
    #------( Formatting )------#
    #
    @always_inline
    fn to_string(self) -> String:
        """Formats the hybrid as a String."""
        return self.__str__()

    @always_inline
    fn __str__(self) -> String:
        """Formats the hybrid as a String."""
        @parameter
        if size == 1:
            return str(self.s) + " + " + str(self.a) + symbol[type,square]()
        else:
            var result: String = ""
            @unroll
            for index in range(size-1): result += str(self.get_hybrid(index)) + "\n"
            return result + str(self.get_hybrid(size-1))


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

    @always_inline
    fn get_hybrid(self, idx: Int) -> HybridSIMD[type,1,square]:
        """
        Gets a hybrid element from the SIMD vector axis.

        Args:
            idx: The index of the hybrid element.

        Returns:
            The hybrid element at position `idx`.
        """
        return HybridSIMD[type,1,square](self.s[idx], self.a[idx])
    
    @always_inline
    fn set_hybrid(inout self, idx: Int, item: HybridSIMD[type,1,square]):
        """
        Sets a hybrid element in the SIMD vector axis.

        Args:
            idx: The index of the hybrid element.
            item: The hybrid element to insert at position `idx`.
        """
        self.s[idx] = item.s
        self.a[idx] = item.a

    @always_inline
    fn get_antiox[square: FloatLiteral](self) -> SIMD[type,size]:
        @parameter
        if sign[type,1,Self.square]() != sign[type,1,square](): return 0
        else: return self.a * (Self.unital_factor / ufac(square))

    @always_inline
    fn set_antiox[square: FloatLiteral](inout self, antiox: SIMD[type,size]):
        constrained[sign[type,1,Self.square]() == sign[type,1,square](), "cannot set antiox. square not contained in this hybrid algebra"]()
        self.a = antiox * (ufac(square) / Self.unital_factor)


    #------( Min / Max )------#
    #
    #--- min
    @always_inline
    fn min_coef(self) -> Self.Coef:
        """Returns the coefficient which is closest to negative infinity."""
        return min(self.s, self.a)
    
    @always_inline
    fn reduce_min(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid element with the smallest measure across the SIMD axis. Remind me to improve implementation."""
        @parameter
        fn _min[size: Int](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]: return min(a,b)
        return self.reduce[_min]()

    @always_inline
    fn reduce_min_coef(self) -> SIMD[type,1]:
        """Returns the smallest value across both the SIMD and Hybrid axis."""
        return min(self.s.reduce_min(), self.a.reduce_min())

    @always_inline
    fn reduce_min_compose(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid vector element which is the composition of the smallest scalar and the smallest antiox across the SIMD axis."""
        return HybridSIMD[type,1,square](self.s.reduce_min(), self.a.reduce_min())
    
    #--- max
    @always_inline
    fn max_coef(self) -> Self.Coef:
        """Returns the coefficient which is closest to positive infinity."""
        return max(self.s, self.a)
    
    @always_inline
    fn reduce_max(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid element with the largest measure across the SIMD axis. Remind me to improve implementation."""
        @parameter
        fn _max[size: Int](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]: return max(a,b)
        return self.reduce[_max]()

    @always_inline
    fn reduce_max_coef(self) -> SIMD[type,1]:
        """Returns the largest value across both the SIMD and Hybrid axis."""
        return max(self.s.reduce_max(), self.a.reduce_max())

    @always_inline
    fn reduce_max_compose(self) -> HybridSIMD[type,1,square]:
        """Returns the hybrid vector element which is the composition of the largest scalar and the largest antiox across the SIMD axis."""
        return HybridSIMD[type,1,square](self.s.reduce_max(), self.a.reduce_max())


    #------( SIMD Vector )------#
    #
    @always_inline
    fn __len__(self) -> Int:
        """Returns the length of the SIMD axis. Guaranteed to be a power of 2."""
        return size

    # splat?

    @always_inline
    fn fma(self, mul: SIMD[type,size], acc: SIMD[type,size]) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type,size,square](self.s.fma(mul, acc), self.a*mul)

    @always_inline
    fn fma[__:None=None](self, mul: Self, acc: SIMD[type,size]) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type,size,square](self.s.fma(mul.s, self.a.fma(square*mul.a, acc)), self.s.fma(mul.a, self.a*mul.s))

    @always_inline
    fn fma[__:None=None](self, mul: SIMD[type,size], acc: Self) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type,size,square](self.s.fma(mul, acc.s), self.a.fma(mul, acc.a))

    @always_inline
    fn fma[__:None=None, ___:None=None](self, mul: Self, acc: Self) -> Self:
        """Fused multiply add."""
        return HybridSIMD[type,size,square](self.s.fma(mul.s, self.a.fma(square*mul.a, acc.s)), self.s.fma(mul.a, self.a.fma(mul.s, acc.a)))

    @always_inline
    fn shuffle[*mask: Int](self) -> Self:
        """Shuffle elements along the SIMD axis using a permutation mask."""
        return Self(self.s._shuffle_list[mask](self.s), self.a._shuffle_list[mask](self.a))

    @always_inline
    fn shuffle[*mask: Int](self, other: Self) -> Self:
        """Shuffle elements along the SIMD axis using a permutation mask and add to other."""
        return Self(self.s._shuffle_list[mask](other.s), self.a._shuffle_list[mask](other.a))

    @always_inline
    fn slice[slice_size: Int](self, offset: Int) -> HybridSIMD[type,slice_size,square]:
        """Returns a slice of the HybridSIMD vector with the specified size at a given offset."""
        return HybridSIMD[type,slice_size,square](self.s.slice[slice_size](offset), self.a.slice[slice_size](offset))

    @always_inline
    fn join(self, other: Self) -> HybridSIMD[type,2*size,square]:
        """Concatenates the two HybridSIMD vectors together."""
        return HybridSIMD[type,2*size,square](self.s.join(other.s), self.a.join(other.a))

    @always_inline
    fn interleave(self, other: Self) -> HybridSIMD[type,2*size,square]:
        """Returns a HybridSIMD vector that alternates between the two inputs."""
        return HybridSIMD[type,2*size,square](self.s.interleave(other.s), self.a.interleave(other.a))

    @always_inline
    fn deinterleave(self) -> StaticTuple[HybridSIMD[type,size//2,square], 2]:
        """Deinterleaves this HybridSIMD vector into even and odd indicies."""
        var s = self.s.deinterleave()
        var a = self.a.deinterleave()
        return StaticTuple[HybridSIMD[type,size//2,square], 2](HybridSIMD[type,size//2,square](s[0],a[0]), HybridSIMD[type,size//2,square](s[1],a[1]))

    @always_inline
    fn reduce[
        func: fn[size: Int](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) capturing -> HybridSIMD[type,size,square], 
        size_out: Int = 1
        ](self) -> HybridSIMD[type,size_out,square]:
        """Calls func recursively on this HybridSIMD to reduce it to the specified size."""
        @parameter
        if size_out >= size:
            return self.slice[size_out](0)
        else:
            var reduced = self.reduce[func, 2*size_out]()
            return func(reduced.slice[size_out](0), reduced.slice[size_out](size_out))

    @always_inline
    fn reduce_add(self) -> HybridSIMD[type,1,square]:
        """Returns the sum of all Hybrid elements accross the SIMD axis."""
        @parameter
        fn _add[size: Int](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]: return a + b
        return self.reduce[_add]()

    @always_inline
    fn reduce_mul(self) -> HybridSIMD[type,1,square]:
        """Returns the product of all Hybrid elements accross the SIMD axis."""
        @parameter
        fn _mul[size: Int](a: HybridSIMD[type,size,square], b: HybridSIMD[type,size,square]) -> HybridSIMD[type,size,square]: return a * b
        return self.reduce[_mul]()

    @always_inline
    fn rotate_left[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount (with wrap)."""
        return Self(self.s.rotate_left[shift](), self.a.rotate_left[shift]())
    
    @always_inline
    fn rotate_right[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount (with wrap)."""
        return Self(self.s.rotate_right[shift](), self.a.rotate_right[shift]())
    
    @always_inline
    fn shift_left[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount."""
        return Self(self.s.shift_left[shift](), self.a.shift_left[shift]())
    
    @always_inline
    fn shift_right[shift: Int](self) -> Self:
        """Returns this HybriSIMD vector shifted along the SIMD axis by the specified amount."""
        return Self(self.s.shift_right[shift](), self.a.shift_right[shift]())


    #------( Comparison )------#
    #
    @always_inline
    fn __lt__(self, other: Self) -> SIMD[DType.bool,size]:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's."""
        return self.contrast() < other.contrast()

    @always_inline
    fn __lt__(self, other: Self.Coef) -> SIMD[DType.bool,size]:
        """Defines the `<` less-than operator. Returns true if the hybrids measure is less than the other's."""
        return self.contrast() < contrast[square](other)

    @always_inline
    fn __le__(self, other: Self) -> SIMD[DType.bool,size]:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's."""
        return self.contrast() <= other.contrast()

    @always_inline
    fn __le__(self, other: Self.Coef) -> SIMD[DType.bool,size]:
        """Defines the `<=` less-than-or-equal operator. Returns true if the hybrids measure is less than or equal to the other's."""
        return self.contrast() <= contrast[square](other)

    @always_inline
    fn __eq__(self, other: Self) -> SIMD[DType.bool,size]:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.s == other.s and self.a == other.a

    @always_inline
    fn __eq__(self, other: Self.Coef) -> SIMD[DType.bool,size]:
        """Defines the `==` equality operator. Returns true if the hybrid numbers are equal."""
        return self.s == other and self.a == 0
    
    @always_inline
    fn __ne__(self, other: Self) -> SIMD[DType.bool,size]:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal."""
        return self.s != other.s or self.a != other.a

    @always_inline
    fn __ne__(self, other: Self.Coef) -> SIMD[DType.bool,size]:
        """Defines the `!=` inequality operator. Returns true if the hybrid numbers are not equal."""
        return self.s != other or self.a != 0

    @always_inline
    fn __gt__(self, other: Self) -> SIMD[DType.bool,size]:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's."""
        return self.contrast() > other.contrast()

    @always_inline
    fn __gt__(self, other: Self.Coef) -> SIMD[DType.bool,size]:
        """Defines the `>` greater-than operator. Returns true if the hybrids measure is greater than the other's."""
        return self.contrast() > contrast[square](other)

    @always_inline
    fn __ge__(self, other: Self) -> SIMD[DType.bool,size]:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's."""
        return self.contrast() >= other.contrast()

    @always_inline
    fn __ge__(self, other: Self.Coef) -> SIMD[DType.bool,size]:
        """Defines the `>=` greater-than-or-equal operator. Returns true if the hybrids measure is greater than or equal to the other's."""
        return self.contrast() >= contrast[square](other)


    #------( Unary )------#
    #
    @always_inline
    fn __neg__(self) -> Self:
        """Defines the unary `-` negative operator. Returns the negative of this hybrid number."""
        return Self(-self.s, -self.a)
    
    @always_inline
    fn __invert__(self) -> Self:
        """
        Defines the unary `~` invert operator. Performs bit-wise invert.
        
        SIMD type must be integral (or boolean).

        Returns:
            The bit-wise inverted hybrid number.
        """
        return Self(~self.s, ~self.a) # could define different behaviour. bit invert is not used very often with complex types.
    
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
            Complex   -> [0]*[0] + [1]*[1]
            Paraplex  -> [0]*[0]
            Hyperplex -> [0]*[0] - [1]*[1]

        Parameters:
            absolute: Setting this true will ensure a positive result.

        Returns:
            The hybrid denomer.
        """
        @parameter
        if absolute: return abs(self.inner(self))
        else: return self.inner(self)

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

        Parameters:
            absolute: Setting this true will ensure a definite result.

        Returns:
            The hybrid measure.
        """
        @parameter
        if square == 0: return abs(self.s)
        else: return sqrt(self.denomer[absolute]())

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
        if square == 0: return log(self.measure())
        else: return log(self.denomer[absolute]())/2

    # # figure our how to best rectify imaginary modulus from hyperplex numbers
    # @always_inline
    # fn modulus(self) -> HybridSIMD[type,size,-1]:
    #     """
    #     Get the modulus of this hybrid number.

    #     This is similar to the magnitude of a hybrid number, but returns a complex number to handle special cases.
    #     """
    #     @parameter
    #     if square != 0: return sqrt(HybridSIMD[type,size,-1](self.denomer[False]()))
    #     return abs(self.s)

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

    @always_inline # Hybrid + Hybrid
    fn __add__[square: FloatLiteral, __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) + other

    #--- subtraction
    @always_inline # Hybrid - Scalar
    fn __sub__(self, other: Self.Coef) -> Self:
        return Self(self.s - other, self.a)
    
    @always_inline # Hybrid - Hybrid
    fn __sub__[__:None=None](self, other: Self) -> Self:
        return Self(self.s - other.s, self.a - other.a)

    @always_inline # Hybrid - Hybrid
    fn __sub__[square: FloatLiteral, __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return MultiplexSIMD(self) - other

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
        return (self*other.conjugate()) / other.denomer()

    @always_inline # Hybrid // Scalar
    fn __floordiv__(self, other: Self.Coef) -> Self:
        return Self(self.s // other, self.a // other)

    @always_inline # Hybrid // Hybrid
    fn __floordiv__[__:None=None](self, other: Self) -> Self:
        return (self*other.conjugate()) // other.denomer()

    #--- exponentiation
    @always_inline # Hybrid ** Scalar
    fn __pow__(self, other: Self.Coef) -> Self:
        return pow(self, other)

    @always_inline # Hybrid ** Hybrid
    fn __pow__[__:None=None](self, other: Self) -> Self:
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

    @always_inline # Hybrid + Hybrid
    fn __radd__[square: FloatLiteral, __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
        return other + self

    #--- subtraction
    @always_inline # Scalar - Hybrid
    fn __rsub__(self, other: Self.Coef) -> Self:
        return Self(other - self.s, -self.a)

    @always_inline # Hybrid - Hybrid
    fn __rsub__[__:None=None](self, other: Self) -> Self:
        return other - self

    @always_inline # Hybrid - Hybrid
    fn __rsub__[square: FloatLiteral, __:None=None](self, other: HybridSIMD[type,size,square]) -> MultiplexSIMD[type,size]:
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
    fn __rpow__[__:None=None](self, other: Self) -> Self:
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