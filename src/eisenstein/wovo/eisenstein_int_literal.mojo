# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +--------------------------------------------------------------------------+ #
# | Eisenstein Integer Literal (wo (+) vo)
# +--------------------------------------------------------------------------+ #
#
@nonmaterializable(EisInt_wovo)
@register_passable("trivial")
struct EisIntLiteral_wovo(StringableCollectionElement, EqualityComparable):

    # +------[ Alias ]------+ #
    #
    alias Coef = IntLiteral


    # +------< Data >------+ #
    #
    var wo: Self.Coef
    var vo: Self.Coef


    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self, re: Self.Coef = 0):
        self.wo = -re
        self.vo = -re

    @always_inline("nodebug")
    fn __init__(inout self, wo: Self.Coef, vo: Self.Coef):
        self.wo = wo
        self.vo = vo

    @always_inline("nodebug")
    fn __init__(inout self, wo: Self.Coef, po: Self.Coef, vo: Self.Coef):
        self.wo = wo-po
        self.vo = vo-po
    

    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(a: Self, b: Self) -> Self:
        return Self(a.wo + b.wo, a.vo + b.vo)
    
    @always_inline("nodebug")
    """wo_add acts more like subtract than add."""
    fn wo_add(a: Self, b: Self) -> Self:
        return Self(a.wo - b.vo, a.vo + b.wo - b.vo)
    
    @always_inline("nodebug")
    """vo_add acts more like subtract than add."""
    fn vo_add(a: Self, b: Self) -> Self:
        return Self(a.wo + b.vo - b.wo, a.vo - b.wo)
    
    @always_inline("nodebug")
    fn __sub__(a: Self, b: Self) -> Self:
        return Self(a.wo - b.wo, a.vo - b.vo)
    
    @always_inline("nodebug")
    """wo_sub acts more like add than subtract."""
    fn wo_sub(a: Self, b: Self) -> Self:
        return Self(a.wo + b.vo, a.vo - b.wo + b.vo)
    
    @always_inline("nodebug")
    """vo_sub acts more like add than subtract."""
    fn vo_sub(a: Self, b: Self) -> Self:
        return Self(a.wo - b.vo + b.wo, a.vo + b.wo)
    
    @always_inline("nodebug")
    fn __mul__(a: Self, b: Self.Coef) -> Self:
        return Self(a.wo*b, a.vo*b)
    
    @always_inline("nodebug")
    fn __mul__(a: Self, b: Self) -> Self:
        var c: Self.Coef = a.wo*b.vo + a.vo*b.wo
        return Self(a.vo*b.vo - c, a.wo*b.wo - c)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.wo//b, a.vo//b)
    
    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self) -> Self:
        return (a*b.conj()) // (b.wo*b.wo + b.vo*b.vo - b.wo*b.vo)
    

    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn coef_po(self) -> Self.Coef:
        """Gets the positive component, or 0 if there is none."""
        return _max(_max(0, -self.wo), _max(0, -self.vo))
    
    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        """Gets the upper left component, or 0 if there is none."""
        return _max(0, self.wo + _max(0, -self.vo))
    
    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        """Gets the bottom left component, or 0 if there is none."""
        return _max(0, self.vo + _max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        """Gets the negative component, or 0 if there is none."""
        return _max(_max(0, self.wo), _max(0, self.vo))
    
    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        """Gets the upper right component, or 0 if there is none."""
        return _max(0, -self.wo + _max(0, self.vo))
    
    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        """Gets the bottom right component, or 0 if there is none."""
        return _max(0, -self.vo + _max(0, self.wo))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> Bool:
        return (self.wo == other.wo) & (self.vo == other.vo)

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> Bool:
        return (self.wo != other.wo) | (self.vo != other.vo)


    # +------( Unary )------+ #
    #
    @always_inline("nodebug")
    fn __neg__(self) -> Self:
        return Self(-self.wo, -self.vo)

    @always_inline("nodebug")
    fn conj(self) -> Self:
        return Self(self.vo, self.wo)
    

    # +------( Format )------+ #
    #
    @no_inline
    fn __str__(self) -> String:
        return EisInt_wovo(self).__str__()

    @no_inline
    fn format_to(self, inout writer: Formatter):
        EisInt_wovo(self).format_to(writer)

    @no_inline
    fn format_to[fmt: StringLiteral](self, inout writer: Formatter):
        EisInt_wovo(self).format_to[fmt](writer)