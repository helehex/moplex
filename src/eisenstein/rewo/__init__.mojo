# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Eisenstein `(re (+) wo)`"""

from .eisenstein_int_literal import EisIntLiteral_rewo
from .eisenstein_simd import EisSIMD_rewo

alias EisInt_rewo = EisSIMD_rewo[DType.index, 1]
