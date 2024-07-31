# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #
"""Eisenstein `(wo (+) vo)`"""

from .eisenstein_int_literal import EisIntLiteral_wovo
from .eisenstein_simd import EisSIMD_wovo

alias EisInt_wovo = EisSIMD_wovo[DType.index, 1]
