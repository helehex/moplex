# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from moplex import *

alias simd_type: DType = DType.float64
alias simd_size = 4
alias square = 1


fn static_test():
    # +--- define
    var int_literal: IntLiteral = 2
    var hybrid_int_literal: HybridIntLiteral[square] = HybridIntLiteral[square](2)

    var float_literal: FloatLiteral = 2.0
    var hybrid_float_literal: HybridFloatLiteral[square] = HybridFloatLiteral[square](2)

    var int: Int = Int(2)
    var hybrid_int: HybridInt[square] = HybridInt[square](2,1)

    var float: SIMD[simd_type,1] = SIMD[simd_type,1](2)
    var hybrid_float: HybridSIMD[simd_type,1,square] = HybridSIMD[simd_type,1,square](2)

    var simd: SIMD[simd_type,simd_size] = SIMD[simd_type,simd_size](2)
    var hybrid_simd: HybridSIMD[simd_type,simd_size,square] = HybridSIMD[simd_type,simd_size,square](2)

    var multiplex: MultiplexSIMD[simd_type,simd_size] = MultiplexSIMD[simd_type,simd_size](2)


    # +--- hybrid_int_literal
    hybrid_int_literal = int_literal
    hybrid_int_literal = HybridIntLiteral[square](2,2)

    hybrid_int_literal = hybrid_int_literal + int_literal
    hybrid_int_literal = int_literal + hybrid_int_literal

    hybrid_int_literal = hybrid_int_literal + hybrid_int_literal

    hybrid_int_literal += int_literal
    hybrid_int_literal += hybrid_int_literal
    
    # (supposed to not work)
    # alias hybrid_int_literal_ = hybrid_int_literal + i


    # +--- hybrid_float_literal
    hybrid_float_literal = int_literal
    hybrid_float_literal = hybrid_int_literal
    hybrid_float_literal = float_literal
    hybrid_float_literal = HybridFloatLiteral[square](2,2)

    hybrid_float_literal = hybrid_float_literal + int_literal
    hybrid_float_literal = int_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_int_literal + float_literal
    hybrid_float_literal = float_literal + hybrid_int_literal

    hybrid_float_literal = hybrid_float_literal + hybrid_int_literal
    hybrid_float_literal = hybrid_int_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + float_literal
    hybrid_float_literal = float_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + hybrid_float_literal

    hybrid_float_literal += int_literal
    hybrid_float_literal += hybrid_int_literal
    hybrid_float_literal += float_literal
    hybrid_float_literal += hybrid_float_literal

    # (supposed to not work)
    # hybrid_float_literal = hybrid_float_literal + i


    # +--- hybrid_int
    hybrid_int = int_literal
    hybrid_int = hybrid_int_literal
    hybrid_int = int
    hybrid_int = HybridInt[square](2,2)


    hybrid_int = hybrid_int + int_literal
    hybrid_int = int_literal + hybrid_int

    hybrid_int = hybrid_int + hybrid_int_literal
    hybrid_int = hybrid_int_literal + hybrid_int

    hybrid_int = hybrid_int + int
    hybrid_int = int + hybrid_int

    hybrid_int = hybrid_int + hybrid_int

    hybrid_int += int_literal
    hybrid_int += hybrid_int_literal
    hybrid_int += int
    hybrid_int += hybrid_int


    # +--- hybrid_simd
    hybrid_simd = int_literal
    hybrid_simd = hybrid_int_literal
    hybrid_simd = float_literal
    hybrid_simd = hybrid_float_literal
    hybrid_simd = int
    hybrid_simd = hybrid_int
    hybrid_simd = float
    hybrid_simd = hybrid_float
    hybrid_simd = HybridSIMD[simd_type,simd_size,square](float, float)

    hybrid_simd = hybrid_simd + int_literal
    hybrid_simd = int_literal + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_int_literal
    hybrid_simd = hybrid_int_literal + hybrid_simd

    hybrid_simd = hybrid_simd + float_literal
    hybrid_simd = float_literal + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_float_literal
    hybrid_simd = hybrid_float_literal + hybrid_simd

    hybrid_simd = hybrid_simd + int
    hybrid_simd = int + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_int
    hybrid_simd = hybrid_int + hybrid_simd

    hybrid_simd = float + hybrid_int
    hybrid_simd = hybrid_int + float

    hybrid_simd = simd + hybrid_int
    hybrid_simd = hybrid_int + simd

    hybrid_simd = hybrid_simd + float
    hybrid_simd = float + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_float
    hybrid_simd = hybrid_float + hybrid_simd

    hybrid_simd = hybrid_simd + simd
    hybrid_simd = simd + hybrid_simd

    hybrid_simd = hybrid_simd + hybrid_simd

    hybrid_simd += int_literal
    hybrid_simd += hybrid_int_literal
    hybrid_simd += float_literal
    hybrid_simd += hybrid_float_literal
    hybrid_simd += int
    hybrid_simd += hybrid_int
    hybrid_simd += float
    hybrid_simd += hybrid_float
    hybrid_simd += simd
    hybrid_simd += hybrid_simd

    hybrid_simd.setlane(0, hybrid_int_literal)


    # +--- multiplex
    multiplex = Hyperplex64(1,1) + Complex64(1,1) + Dualplex64(1,1)

    multiplex = int_literal
    multiplex = hybrid_int_literal
    multiplex = float_literal
    multiplex = hybrid_float_literal
    multiplex = int
    multiplex = hybrid_int
    multiplex = float
    multiplex = hybrid_float
    multiplex = simd
    multiplex = hybrid_simd
    
    multiplex = multiplex.__add__(Hyperplex64(1,1))
    multiplex = Hyperplex64(1,1) + multiplex

    multiplex = multiplex + Complex64(1,1)
    multiplex = Complex64(1,1) + multiplex

    multiplex = multiplex + Dualplex64(1,1)
    multiplex = Dualplex64(1,1) + multiplex

    multiplex = multiplex + int_literal
    multiplex = int_literal + multiplex

    multiplex = multiplex + hybrid_int_literal
    multiplex = hybrid_int_literal + multiplex

    multiplex = multiplex + float_literal
    multiplex = float_literal + multiplex

    multiplex = multiplex + hybrid_float_literal
    multiplex = hybrid_float_literal + multiplex

    multiplex = multiplex + int
    multiplex = int + multiplex

    multiplex = multiplex + hybrid_int
    multiplex = hybrid_int + multiplex

    multiplex = multiplex + float
    multiplex = float + multiplex

    multiplex = multiplex + hybrid_float
    multiplex = hybrid_float + multiplex

    multiplex = multiplex + simd
    multiplex = simd + multiplex

    multiplex = multiplex + hybrid_simd
    multiplex = hybrid_simd + multiplex

    multiplex = MultiplexSIMD[simd_type,1](1) + multiplex