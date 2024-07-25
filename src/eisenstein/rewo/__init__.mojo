# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #
"""Eisenstein `(re (+) wo)`"""

from .eisenstein_int_literal import LitIntE_rewo
from .eisenstein_simd import ESIMD_rewo

alias IntE_rewo = ESIMD_rewo[DType.index,1]