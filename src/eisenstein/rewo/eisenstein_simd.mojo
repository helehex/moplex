# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +--------------------------------------------------------------------------+ #
# | Eisenstein SIMD (re (+) wo)
# +--------------------------------------------------------------------------+ #
#
@value
@register_passable("trivial")
struct ESIMD_rewo[dt: DType, sw: Int](StringableCollectionElement, EqualityComparable):

    # +------[ Alias ]------+ #
    #
    alias Lit = LitIntE_rewo
    alias Coef = SIMD[dt,sw]
    alias Unit = ESIMD_rewo[dt,1]


    # +------< Data >------+ #
    #
    var re: Self.Coef
    var wo: Self.Coef


    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(lit: Self.Lit) -> Self:
        return Self{re: lit.re, wo: lit.wo}

    @always_inline("nodebug")
    fn __init__(lit: Self.Lit.Coef) -> Self:
        return Self{re: lit, wo: 0}

    @always_inline("nodebug")
    fn __init__(re: Self.Coef, wo: Self.Coef = 0) -> Self:
        return Self{re: re, wo: wo}

    @always_inline("nodebug")
    fn __init__(wo: Self.Coef, po: Self.Coef, vo: Self.Coef) -> Self:
        return Self{re: po-vo, wo: wo-vo}
    

    # +------( Arithemtic )------+ #
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
        var c = -(a.wo * b.wo)
        return Self((a.re * b.re) + c, (a.re * b.wo) + (a.wo * b.re) + c)
    
    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.re//b, a.wo//b)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self) -> Self:
        var div = b.re*b.re + b.wo*b.wo - b.re*b.wo
        var arebwo = a.re * b.wo
        return Self(a.re*b.re + a.wo*b.wo - arebwo, a.wo*b.re - arebwo) // div


    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.re[index], self.wo[index])

    @always_inline("nodebug")
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.re[index] = item.re
        self.wo[index] = item.wo
    
    @always_inline("nodebug")
    fn coef_po(self) -> Self.Coef:
        return max(0, self.re + max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        return max(0, self.wo + max(0, -self.re))
    
    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        return max(max(0, -self.re), max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        return max(0, -self.re + max(0, self.wo))
    
    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        return max(0, -self.wo + max(0, self.re))

    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        return max(max(0, self.re), max(0, self.wo))


    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, sw]:
        return (self.re == other.re) & (self.wo == other.wo)

    @always_inline("nodebug")
    fn __eq__[__:None=None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, sw]:
        return (self.re != other.re) & (self.wo != other.wo)

    @always_inline("nodebug")
    fn __ne__[__:None=None](self, other: Self) -> Bool:
        return any(self.__ne__(other))


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
    fn str_rewo[seperator: String = "\n"](self) -> String:
        @parameter
        if sw == 1:
            return str(self.re) + "wo + " + str(self.wo) + "vo"
        var result: String = ""
        @parameter
        for i in range(sw - 1):
            result += self[i].str_rewo() + seperator
        return result + self[sw - 1].str_rewo()
            
    @always_inline("nodebug")
    fn str_po[seperator: String = "\n"](self) -> String:
        @parameter
        if sw == 1:
            return "(" + str(self.coef_powo()) + "<+" + str(self.coef_po()) + "+>" + str(self.coef_povo()) + ")"
        var result: String = ""
        @parameter
        for i in range(sw - 1):
            result += self[i].str_po() + seperator
        return result + self[sw - 1].str_po()
    
    @always_inline("nodebug")
    fn str_ne[seperator: String = "\n"](self) -> String:
        @parameter
        if sw == 1:
            return "(" + str(self.coef_newo()) + "->" + str(self.coef_ne()) + "<-" + str(self.coef_nevo()) + ")"
        var result: String = ""
        @parameter
        for i in range(sw - 1):
            result += self[i].str_ne() + seperator
        return result + self[sw - 1].str_ne()
    
    @always_inline("nodebug")
    fn str_[seperator: String = " "](self) -> String:
        return self.str_po[seperator]()

    @always_inline("nodebug")
    fn print_rewo[seperator: String = "\n"](self):
        print(self.str_rewo[seperator]())

    @always_inline("nodebug")
    fn print_po[seperator: String = "\n"](self):
        print(self.str_po[seperator]())
    
    @always_inline("nodebug")
    fn print_ne[seperator: String = "\n"](self):
        print(self.str_ne[seperator]())

    @always_inline("nodebug")
    fn print_[seperator: String = " "](self):
        self.print_po[seperator]()