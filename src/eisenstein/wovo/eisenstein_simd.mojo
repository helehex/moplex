# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #


# +--------------------------------------------------------------------------+ #
# | Eisenstein SIMD (wo (+) vo)
# +--------------------------------------------------------------------------+ #
#
@value
@register_passable("trivial")
struct ESIMD_wovo[dt: DType, sw: Int](StringableCollectionElement, EqualityComparable):

    # +------[ Alias ]------+ #
    #
    alias Lit = LitIntE_wovo
    alias Coef = SIMD[dt,sw]
    alias Unit = ESIMD_wovo[dt,1]


    # +------< Data >------+ #
    #
    var wo: Self.Coef
    var vo: Self.Coef
    

    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(lit: Self.Lit) -> Self:
        return Self{wo: lit.wo, vo: lit.vo}
    
    @always_inline("nodebug")
    fn __init__(re: Self.Coef) -> Self:
        return Self{wo: -re, vo: -re}
    
    @always_inline("nodebug")
    fn __init__(wo: Self.Coef, vo: Self.Coef) -> Self:
        return Self{wo: wo, vo: vo}

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
        var c = a.wo*b.vo + a.vo*b.wo
        return Self(a.vo*b.vo - c, a.wo*b.wo - c)

    @always_inline("nodebug")
    fn __truediv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.wo/b, a.vo/b)
    
    @always_inline("nodebug")
    fn __truediv__(a: Self, b: Self) -> Self:
        return (a*b.conj()) / (b.wo*b.wo + b.vo*b.vo - b.wo*b.vo)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.wo//b, a.vo//b)
    
    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self) -> Self:
        return (a*b.conj()) // (b.wo*b.wo + b.vo*b.vo - b.wo*b.vo)
    

    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn __getitem__(self, index: Int) -> Self.Unit:
        return Self.Unit(self.wo[index], self.vo[index])

    @always_inline("nodebug")
    fn __setitem__(inout self, index: Int, item: Self.Unit):
        self.wo[index] = item.wo
        self.vo[index] = item.vo

    @always_inline("nodebug")
    fn coef_po(self) -> Self.Coef:
        return max(max(0, -self.wo), max(0, -self.vo))
    
    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        return max(0, self.wo + max(0, -self.vo))
    
    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        return max(0, self.vo + max(0, -self.wo))
    
    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        return max(max(0, self.wo), max(0, self.vo))
    
    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        return max(0, -self.wo + max(0, self.vo))
    
    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        return max(0, -self.vo + max(0, self.wo))
    

    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, sw]:
        return (self.wo == other.wo) & (self.vo == other.vo)

    @always_inline("nodebug")
    fn __eq__[__:None=None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, sw]:
        return (self.wo != other.wo) & (self.vo != other.vo)

    @always_inline("nodebug")
    fn __ne__[__:None=None](self, other: Self) -> Bool:
        return any(self.__ne__(other))


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
    fn str_wovo[seperator: String = "\n"](self) -> String:
        @parameter
        if sw == 1:
            return str(self.wo) + "wo + " + str(self.vo) + "vo"
        var result: String = ""
        @parameter
        for i in range(sw - 1):
            result += self[i].str_wovo() + seperator
        return result + self[sw - 1].str_wovo()
            
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
    fn print_wovo[seperator: String = "\n"](self):
        print(self.str_wovo[seperator]())

    @always_inline("nodebug")
    fn print_po[seperator: String = "\n"](self):
        print(self.str_po[seperator]())
    
    @always_inline("nodebug")
    fn print_ne[seperator: String = "\n"](self):
        print(self.str_ne[seperator]())

    @always_inline("nodebug")
    fn print_[seperator: String = " "](self):
        self.print_po[seperator]()