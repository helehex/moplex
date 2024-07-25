# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +--------------------------------------------------------------------------+ #
# | Eisenstein Integer Literal (wo (+) vo)
# +--------------------------------------------------------------------------+ #
#
@value
@nonmaterializable(IntE_wovo)
@register_passable("trivial")
struct LitIntE_wovo(StringableCollectionElement, EqualityComparable):

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
    fn __init__(re: Self.Coef) -> Self:
        return Self{wo: -re, vo: -re}

    @always_inline("nodebug")
    fn __init__(wo: Self.Coef, po: Self.Coef, vo: Self.Coef) -> Self:
        return Self{wo: wo-po, vo: vo-po}
    

    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(a: Self, b: Self) -> Self:
        return Self(a.wo + b.wo, a.vo + b.vo)
    
    @always_inline("nodebug") # wo_add acts more like subtract than add
    fn wo_add(a: Self, b: Self) -> Self:
        return Self(a.wo - b.vo, a.vo + b.wo - b.vo)
    
    @always_inline("nodebug") # vo_add acts more like subtract than add
    fn vo_add(a: Self, b: Self) -> Self:
        return Self(a.wo + b.vo - b.wo, a.vo - b.wo)
    
    @always_inline("nodebug")
    fn __sub__(a: Self, b: Self) -> Self:
        return Self(a.wo - b.wo, a.vo - b.vo)
    
    @always_inline("nodebug") # wo_sub acts more like add than subtract
    fn wo_sub(a: Self, b: Self) -> Self:
        return Self(a.wo + b.vo, a.vo - b.wo + b.vo)
    
    @always_inline("nodebug") # vo_sub acts more like add than subtract
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
        return _max(_max(0, -self.wo), _max(0, -self.vo))
    
    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        return _max(0, self.wo + _max(0, -self.vo))
    
    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        return _max(0, self.vo + _max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        return _max(_max(0, self.wo), _max(0, self.vo))
    
    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        return _max(0, -self.wo + _max(0, self.vo))
    
    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        return _max(0, -self.vo + _max(0, self.wo))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> Bool:
        return self.wo == other.wo and self.vo == other.vo

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> Bool:
        return self.wo != other.wo or self.vo != other.vo


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
    @always_inline("nodebug")
    fn __str__(self) -> String:
        return self.str_()

    @always_inline("nodebug")
    fn str_wovo(self) -> String:
        return String(self.wo) + "wo + " + String(self.vo) + "vo"
    
    @always_inline("nodebug")
    fn str_po(self) -> String:
        return "(" + String(self.coef_powo()) + "<+" + String(self.coef_po()) + "+>" + String(self.coef_povo()) + ")"

    @always_inline("nodebug")
    fn str_ne(self) -> String:
        return "(" + String(self.coef_newo()) + "->" + String(self.coef_ne()) + "<-" + String(self.coef_nevo()) + ")"

    @always_inline("nodebug")
    fn str_(self) -> String:
        return self.str_po()

    @always_inline("nodebug")
    fn print_wovo(self):
        print(self.str_wovo())

    @always_inline("nodebug")
    fn print_po(self):
        print(self.str_po())

    @always_inline("nodebug")
    fn print_ne(self):
        print(self.str_ne())
    
    @always_inline("nodebug")
    fn print_(self):
        self.print_po()