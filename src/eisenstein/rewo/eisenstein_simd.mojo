# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


# +----------------------------------------------------------------------------------------------+ #
# | Eisenstein SIMD (re (+) wo)
# +----------------------------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct EisSIMD_rewo[type: DType = DType.index, size: Int = 1](
    Formattable, StringableCollectionElement, EqualityComparable
):
    # +------[ Alias ]------+ #
    #
    alias Lit = EisIntLiteral_rewo
    alias Coef = SIMD[type, size]
    alias Lane = EisSIMD_rewo[type, 1]

    # +------< Data >------+ #
    #
    var re: Self.Coef
    var wo: Self.Coef

    # +------( Initialize )------+ #
    #
    @always_inline("nodebug")
    fn __init__(inout self, lit: Self.Lit.Coef):
        self.re = lit
        self.wo = 0

    @always_inline("nodebug")
    fn __init__(inout self, re: Self.Coef, wo: Self.Coef = 0):
        self.re = re
        self.wo = wo

    @always_inline("nodebug")
    fn __init__(inout self, wo: Self.Coef, po: Self.Coef, vo: Self.Coef):
        self.re = po - vo
        self.wo = wo - vo

    @always_inline("nodebug")
    fn __init__(inout self, lit: Self.Lit):
        self.re = lit.re
        self.wo = lit.wo

    # +------( Arithemtic )------+ #
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
        var c = -(a.wo * b.wo)
        return Self((a.re * b.re) + c, (a.re * b.wo) + (a.wo * b.re) + c)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.re // b, a.wo // b)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self) -> Self:
        var div = b.re * b.re + b.wo * b.wo - b.re * b.wo
        var arebwo = a.re * b.wo
        return (
            Self(a.re * b.re + a.wo * b.wo - arebwo, a.wo * b.re - arebwo)
            // div
        )

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
    fn __getitem__(self, index: Int) -> Self.Lane:
        return Self.Lane(self.re[index], self.wo[index])

    @always_inline("nodebug")
    fn __setitem__(inout self, index: Int, item: Self.Lane):
        self.re[index] = item.re
        self.wo[index] = item.wo

    @always_inline("nodebug")
    fn coef_po(self) -> Self.Coef:
        """Gets the positive component, or 0 if there is none."""
        return max(0, self.re + max(0, -self.wo))

    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        """Gets the upper left component, or 0 if there is none."""
        return max(0, self.wo + max(0, -self.re))

    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        """Gets the bottom left component, or 0 if there is none."""
        return max(max(0, -self.re), max(0, -self.wo))

    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        """Gets the negative component, or 0 if there is none."""
        return max(0, -self.re + max(0, self.wo))

    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        """Gets the upper right component, or 0 if there is none."""
        return max(0, -self.wo + max(0, self.re))

    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        """Gets the bottom right component, or 0 if there is none."""
        return max(max(0, self.re), max(0, self.wo))

    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.re == other.re) & (self.wo == other.wo)

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.re != other.re) | (self.wo != other.wo)

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self) -> Bool:
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
    @no_inline
    fn __str__(self) -> String:
        """Formats the hybrid as a String."""
        return String.format_sequence(self)

    @no_inline
    fn format_to(self, inout writer: Formatter):
        self.format_to["po", "\n"](writer)

    @no_inline
    fn format_to[
        fmt: StringLiteral, sep: StringLiteral = "\n"
    ](self, inout writer: Formatter):
        @parameter
        if size == 1:

            @parameter
            if fmt == "rewo":
                writer.write(self.re, " + ", self.wo, "w")
            if fmt == "revo":
                writer.write(self.re - self.wo, " + ", -self.wo, "v")
            elif fmt == "wovo":
                writer.write(self.wo - self.re, "w + ", -self.re, "v")
            elif fmt == "po":
                writer.write(
                    "(",
                    self.coef_powo(),
                    "<+",
                    self.coef_po(),
                    "+>",
                    self.coef_povo(),
                    ")",
                )
            elif fmt == "ne":
                writer.write(
                    "(",
                    self.coef_newo(),
                    "->",
                    self.coef_ne(),
                    "<-",
                    self.coef_nevo(),
                    ")",
                )
        else:

            @parameter
            for lane in range(size - 1):
                self[lane].format_to[fmt, sep](writer)
                writer.write(sep)
            self[size - 1].format_to[fmt, sep](writer)
