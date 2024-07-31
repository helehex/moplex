# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


# +----------------------------------------------------------------------------------------------+ #
# | Eisenstein Integer Literal (re (+) wo)
# +----------------------------------------------------------------------------------------------+ #
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
        self.re = po - vo
        self.wo = wo - vo

    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(a: Self, b: Self) -> Self:
        return Self(a.re + b.re, a.wo + b.wo)

    @always_inline("nodebug")
    fn wo_add(a: Self, b: Self) -> Self:
        """Acts more like subtract than add."""
        return Self(a.re - b.wo, a.wo + b.re - b.wo)

    @always_inline("nodebug")
    fn vo_add(a: Self, b: Self) -> Self:
        """Acts more like subtract than add."""
        return Self(a.re - b.re + b.wo, a.wo - b.re)

    @always_inline("nodebug")
    fn __sub__(a: Self, b: Self) -> Self:
        return Self(a.re - b.re, a.wo - b.wo)

    @always_inline("nodebug")
    fn wo_sub(a: Self, b: Self) -> Self:
        """Acts more like add than subtract."""
        return Self(a.re + b.re - b.wo, a.wo + b.re)

    @always_inline("nodebug")
    fn vo_sub(a: Self, b: Self) -> Self:
        """Acts more like add than subtract."""
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
        return Self(a.re // b, a.wo // b)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self) -> Self:
        var div: Self.Coef = b.re * b.re + b.wo * b.wo - b.re * b.wo
        var arebwo: Self.Coef = a.re * b.wo
        return Self(a.re * b.re + a.wo * b.wo - arebwo, a.wo * b.re - arebwo) // div

    # +------( Subscript )------+ #
    #
    @always_inline("nodebug")
    fn __getattr__(self, attr: StringLiteral) -> Self.Coef:
        if attr == "pore":
            return self.coef_po()
        elif attr == "nere":
            return self.coef_ne()
        elif attr == "powo":
            return self.coef_powo()
        elif attr == "newo":
            return self.coef_newo()
        elif attr == "povo":
            return self.coef_povo()
        elif attr == "nevo":
            return self.coef_nevo()
        else:
            return 0

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
