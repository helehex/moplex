# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #
"""Eisenstein Integers."""

from .wovo import LitIntE_wovo
from .wovo import ESIMD_wovo
from .wovo import IntE_wovo

from .rewo import LitIntE_rewo
from .rewo import ESIMD_rewo
from .rewo import IntE_rewo


#
#             +i
#       +w          -v
#
#
#   -1        0        +1
#
#
#       +v          -w
#             -i    
#
#
# +1  ~ po
# -v  ~ nevo
# +i  ~ poim
# +w  ~ powo
# -1  ~ ne
# +v  ~ povo
# -i  ~ neim
# -w  ~ newo
#
# re  ~ real axis      (+1 -1)
# wo  ~ eisen.+ axis   (+w -w)
# vo  ~ eisen.- axis   (+v -v)
# im  ~ imaginary axis (+i -i)


@always_inline("nodebug")
fn _max(a: IntLiteral, b: IntLiteral) -> IntLiteral:  # <-------- ternary doesnt work for IntLiteral
    if a > b:
        return a
    else:
        return b


@always_inline("nodebug")
fn _min(a: IntLiteral, b: IntLiteral) -> IntLiteral:  # <-------- ternary doesnt work for IntLiteral
    if a < b:
        return a
    else:
        return b