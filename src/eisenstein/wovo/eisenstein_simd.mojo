# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #


# +----------------------------------------------------------------------------------------------+ #
# | Eisenstein SIMD (wo (+) vo)
# +----------------------------------------------------------------------------------------------+ #
#
@register_passable("trivial")
struct EisSIMD_wovo[type: DType = DType.index, size: Int = 1](
    StringableCollectionElement, EqualityComparable
):
    # +------[ Alias ]------+ #
    #
    alias Lit = EisIntLiteral_wovo
    alias Coef = SIMD[type, size]
    alias Unit = EisSIMD_wovo[type, 1]

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
        self.wo = wo - po
        self.vo = vo - po

    @always_inline("nodebug")
    fn __init__(inout self, lit: Self.Lit):
        self.wo = lit.wo
        self.vo = lit.vo

    # +------( Arithmetic )------+ #
    #
    @always_inline("nodebug")
    fn __add__(a: Self, b: Self) -> Self:
        return Self(a.wo + b.wo, a.vo + b.vo)

    @always_inline("nodebug")
    fn wo_add(a: Self, b: Self) -> Self:
        """Acts more like subtract than add."""
        return Self(a.wo - b.vo, a.vo + b.wo - b.vo)

    @always_inline("nodebug")
    fn vo_add(a: Self, b: Self) -> Self:
        """Acts more like subtract than add."""
        return Self(a.wo + b.vo - b.wo, a.vo - b.wo)

    @always_inline("nodebug")
    fn __sub__(a: Self, b: Self) -> Self:
        return Self(a.wo - b.wo, a.vo - b.vo)

    @always_inline("nodebug")
    fn wo_sub(a: Self, b: Self) -> Self:
        """Acts more like add than subtract."""
        return Self(a.wo + b.vo, a.vo - b.wo + b.vo)

    @always_inline("nodebug")
    fn vo_sub(a: Self, b: Self) -> Self:
        """Acts more like add than subtract."""
        return Self(a.wo - b.vo + b.wo, a.vo + b.wo)

    @always_inline("nodebug")
    fn __mul__(a: Self, b: Self.Coef) -> Self:
        return Self(a.wo * b, a.vo * b)

    @always_inline("nodebug")
    fn __mul__(a: Self, b: Self) -> Self:
        var c = a.wo * b.vo + a.vo * b.wo
        return Self(a.vo * b.vo - c, a.wo * b.wo - c)

    @always_inline("nodebug")
    fn __truediv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.wo / b, a.vo / b)

    @always_inline("nodebug")
    fn __truediv__(a: Self, b: Self) -> Self:
        return (a * b.conj()) / (b.wo * b.wo + b.vo * b.vo - b.wo * b.vo)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self.Coef) -> Self:
        return Self(a.wo // b, a.vo // b)

    @always_inline("nodebug")
    fn __floordiv__(a: Self, b: Self) -> Self:
        return (a * b.conj()) // (b.wo * b.wo + b.vo * b.vo - b.wo * b.vo)

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
    fn __getitem__(self, idx: Int) -> Self.Unit:
        return self.get_lane(idx)

    @always_inline("nodebug")
    fn __setitem__(inout self, idx: Int, item: Self.Unit):
        self.set_lane(idx, item)

    @always_inline("nodebug")
    fn get_lane(self, idx: Int) -> Self.Unit:
        return Self.Unit(self.wo[idx], self.vo[idx])

    @always_inline("nodebug")
    fn set_lane(inout self, idx: Int, item: Self.Unit):
        self.wo[idx] = item.wo
        self.vo[idx] = item.vo

    @always_inline("nodebug")
    fn coef_po(self) -> Self.Coef:
        """Gets the positive component, or 0 if there is none."""
        return max(max(0, -self.wo), max(0, -self.vo))

    @always_inline("nodebug")
    fn coef_powo(self) -> Self.Coef:
        """Gets the upper left component, or 0 if there is none."""
        return max(0, self.wo + max(0, -self.vo))

    @always_inline("nodebug")
    fn coef_povo(self) -> Self.Coef:
        """Gets the bottom left component, or 0 if there is none."""
        return max(0, self.vo + max(0, -self.wo))

    @always_inline("nodebug")
    fn coef_ne(self) -> Self.Coef:
        """Gets the negative component, or 0 if there is none."""
        return max(max(0, self.wo), max(0, self.vo))

    @always_inline("nodebug")
    fn coef_newo(self) -> Self.Coef:
        """Gets the upper right component, or 0 if there is none."""
        return max(0, -self.wo + max(0, self.vo))

    @always_inline("nodebug")
    fn coef_nevo(self) -> Self.Coef:
        """Gets the bottom right component, or 0 if there is none."""
        return max(0, -self.vo + max(0, self.wo))

    # +------( Comparison )------+ #
    #
    @always_inline("nodebug")
    fn __eq__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.wo == other.wo) & (self.vo == other.vo)

    @always_inline("nodebug")
    fn __eq__[__: None = None](self, other: Self) -> Bool:
        return all(self.__eq__(other))

    @always_inline("nodebug")
    fn __ne__(self, other: Self) -> SIMD[DType.bool, size]:
        return (self.wo != other.wo) | (self.vo != other.vo)

    @always_inline("nodebug")
    fn __ne__[__: None = None](self, other: Self) -> Bool:
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
                writer.write(-(self.wo + self.vo), " + ", self.wo, "w")
            if fmt == "revo":
                writer.write(-(self.wo + self.vo), " + ", self.vo, "v")
            elif fmt == "wovo":
                writer.write(self.wo, "w + ", self.vo, "v")
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
