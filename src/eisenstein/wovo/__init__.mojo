# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #
"""Eisenstein `(wo (+) vo)`"""

from .eisenstein_int_literal import LitIntE_wovo
from .eisenstein_simd import ESIMD_wovo

alias IntE_wovo = ESIMD_wovo[DType.index,1]