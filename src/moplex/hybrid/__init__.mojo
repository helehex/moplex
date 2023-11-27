"""
Implements Complex, Paraplex, Hyperplex, and Multiplex types, backed by Hybrid.

Complex, Paraplex, and Hyperplex are the three unitized hybrid types.

Multiplex is a composition of the three unitized hybrid types.
"""

from .hybrid_int_literal import *
from .hybrid_float_literal import *
from .hybrid_int import *
from .hybrid_simd import *
from .multiplex_simd import *

# next rework:
# explore parameterizing things on masks and signatures, less hard-coded types