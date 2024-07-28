# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +--------------------------------------------------------------------------+ #
# | Eisenstein Integer Literal (re (+) wo)
# +--------------------------------------------------------------------------+ #
#
@nonmaterializable(EisInt_rewo)
@register_passable("trivial")
struct EisIntLiteral_rewo(EqualityComparable):

    # +------[ Alias ]------+ #
    #
    alias Coef = IntLiteral


    # +------< Data >------+ #
    #
    var re: Self.Coef
    var wo: Self.Coef


    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self, re: Self.Coef, wo: Self.Coef = 0):
        self.re = re
        self.wo = wo

    @always_inline("nodebug")
    fn __init__(inout self, wo: Self.Coef, po: Self.Coef, vo: Self.Coef):
        self.re = po-vo
        self.wo = wo-vo


    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(a: Self, b: Self) -> Self:
        return Self(a.re + b.re, a.wo + b.wo)
    
    @always_inline("nodebug")
    """wo_add acts more like subtract than add."""
    fn wo_add(a: Self, b: Self) -> Self:
        return Self(a.re - b.wo, a.wo + b.re - b.wo)
    
    @always_inline("nodebug")
    """vo_add acts more like subtract than add."""
    fn vo_add(a: Self, b: Self) -> Self:
        return Self(a.re - b.re + b.wo, a.wo - b.re)
    
    @always_inline("nodebug")
    fn __sub__(a: Self, b: Self) -> Self:
        return Self(a.re - b.re, a.wo - b.wo)
    
    @always_inline("nodebug")
    """wo_sub acts more like add than subtract."""
    fn wo_sub(a: Self, b: Self) -> Self:
        return Self(a.re + b.re - b.wo, a.wo + b.re)
    
    @always_inline("nodebug")
    """vo_sub acts more like add than subtract."""
    fn vo_sub(a: Self, b: Self) -> Self:
        return Self(a.re + b.wo, a.wo - b.re + b.wo)
    
    @always_inline("nodebug")
    fn __mul__(a: Self, b: Self.Coef) -> Self:
        return Self(a.re * b, a.wo * b)
    
    @always_inline("nodebug")
    fn __mul__(a: Self, b: Self) -> Self:
        var c: Self.Coef = -(a.wo * b.wo)
        return Self((a.re * b.re) + c, (a.re * b.wo) + (a.wo * b.re) + c)
    
    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.re//b, a.wo//b)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self) -> Self:
        var div: Self.Coef = b.re*b.re + b.wo*b.wo - b.re*b.wo
        var arebwo: Self.Coef = a.re * b.wo
        return Self(a.re*b.re + a.wo*b.wo - arebwo, a.wo*b.re - arebwo) // div
    

    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn coef_po(self) -> Self.Coef:
        """Gets the positive component, or 0 if there is none."""
        return _max(0, self.re + _max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        """Gets the upper left component, or 0 if there is none."""
        return _max(0, self.wo + _max(0, -self.re))
    
    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        """Gets the bottom left component, or 0 if there is none."""
        return _max(_max(0, -self.re), _max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        """Gets the negative component, or 0 if there is none."""
        return _max(0, -self.re + _max(0, self.wo))
    
    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        """Gets the upper right component, or 0 if there is none."""
        return _max(0, -self.wo + _max(0, self.re))

    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        """Gets the bottom right component, or 0 if there is none."""
        return _max(_max(0, self.re), _max(0, self.wo))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> Bool:
        return (self.re == other.re) & (self.wo == other.wo)

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> Bool:
        return (self.re != other.re) | (self.wo != other.wo)


    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.re, -self.wo)

    @always_inline("nodebug")
    fn conj(self) -> Self:
        return Self(self.re - self.wo, -self.wo)
    

    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        return EisInt_rewo(self).__str__()

    @no_inline
    fn format_to(self, inout writer: Formatter):
        EisInt_rewo(self).format_to(writer)

    @no_inline
    fn format_to[fmt: StringLiteral](self, inout writer: Formatter):
        EisInt_rewo(self).format_to[fmt](writer)