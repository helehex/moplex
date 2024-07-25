# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +--------------------------------------------------------------------------+ #
# | Eisenstein Integer Literal (re (+) wo)
# +--------------------------------------------------------------------------+ #
#
@value
@nonmaterializable(IntE_rewo)
@register_passable("trivial")
struct LitIntE_rewo(StringableCollectionElement, EqualityComparable):

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
    fn __init__(re: Self.Coef, wo: Self.Coef = 0) -> Self:
        return Self{re: re, wo: wo}

    @always_inline("nodebug")
    fn __init__(wo: Self.Coef, po: Self.Coef, vo: Self.Coef) -> Self:
        return Self{re: po-vo, wo: wo-vo}


    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(a: Self, b: Self) -> Self:
        return Self(a.re + b.re, a.wo + b.wo)
    
    @always_inline("nodebug") # wo_add acts more like subtract than add
    fn wo_add(a: Self, b: Self) -> Self:
        return Self(a.re - b.wo, a.wo + b.re - b.wo)
    
    @always_inline("nodebug") # vo_add acts more like subtract than add
    fn vo_add(a: Self, b: Self) -> Self:
        return Self(a.re - b.re + b.wo, a.wo - b.re)
    
    @always_inline("nodebug")
    fn __sub__(a: Self, b: Self) -> Self:
        return Self(a.re - b.re, a.wo - b.wo)
    
    @always_inline("nodebug") # wo_sub acts more like add than subtract
    fn wo_sub(a: Self, b: Self) -> Self:
        return Self(a.re + b.re - b.wo, a.wo + b.re)
    
    @always_inline("nodebug") # vo_sub acts more like add than subtract
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
        return _max(0, self.re + _max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        return _max(0, self.wo + _max(0, -self.re))
    
    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        return _max(_max(0, -self.re), _max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        return _max(0, -self.re + _max(0, self.wo))
    
    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        return _max(0, -self.wo + _max(0, self.re))

    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        return _max(_max(0, self.re), _max(0, self.wo))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> Bool:
        return self.re == other.re and self.wo == other.wo

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> Bool:
        return self.re != other.re or self.wo != other.wo


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
    @always_inline("nodebug")
    fn __str__(self) -> String:
        return self.str_()

    @always_inline("nodebug")
    fn str_rewo(self) -> String:
        return String(self.re) + "re + " + String(self.wo) + "wo"
    
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
    fn print_rewo(self):
        print(self.str_rewo())

    @always_inline("nodebug")
    fn print_po(self):
        print(self.str_po())
    
    @always_inline("nodebug")
    fn print_ne(self):
        print(self.str_ne())

    @always_inline("nodebug")
    fn print_(self):
        self.print_po()