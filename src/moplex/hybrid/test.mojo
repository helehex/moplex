from ..momath import *

alias simd_type: DType = DType.float64
alias simd_size = 4

fn static_test():

    let int_literal: IntLiteral = IntLiteral(2)
    var hybrid_int_literal: HybridIntLiteral = HybridIntLiteral(2)

    let float_literal: FloatLiteral = FloatLiteral(2)
    var hybrid_float_literal: HybridFloatLiteral = HybridFloatLiteral(2)

    let int: Int = Int(2)
    var hybrid_int: HybridInt = HybridInt(2,1)

    let float: SIMD[simd_type,1] = SIMD[simd_type,1](2)
    let hybrid_float: HybridSIMD[simd_type,1] = HybridSIMD[simd_type,1](2)

    let simd: SIMD[simd_type,simd_size] = SIMD[simd_type,simd_size](2)
    var hybrid_simd: HybridSIMD[simd_type,simd_size] = HybridSIMD[simd_type,simd_size](2)

    var multiplex: MultiplexSIMD[simd_type,simd_size] = MultiplexSIMD[simd_type,simd_size](2)


    #------ hybrid_int_literal ------#
    #
    hybrid_int_literal = int_literal
    hybrid_int_literal = HybridIntLiteral(2,2)

    hybrid_int_literal = hybrid_int_literal + int_literal
    hybrid_int_literal = int_literal + hybrid_int_literal

    hybrid_int_literal = hybrid_int_literal + hybrid_int_literal

    hybrid_int_literal += int_literal
    hybrid_int_literal += hybrid_int_literal
    

    #alias hybrid_int_literal_ = hybrid_int_literal + i


    #------ hybrid_float_literal ------#
    #
    hybrid_float_literal = int_literal
    hybrid_float_literal = hybrid_int_literal
    hybrid_float_literal = float_literal
    hybrid_float_literal = HybridFloatLiteral(2,2)

    hybrid_float_literal = hybrid_float_literal + int_literal
    hybrid_float_literal = int_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + hybrid_int_literal
    hybrid_float_literal = hybrid_int_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + float_literal
    hybrid_float_literal = float_literal + hybrid_float_literal

    hybrid_float_literal = hybrid_float_literal + hybrid_float_literal

    hybrid_float_literal += int_literal
    hybrid_float_literal += hybrid_int_literal
    hybrid_float_literal += float_literal
    hybrid_float_literal += hybrid_float_literal

    #hybrid_float_literal = hybrid_float_literal + i


    #------ hybrid_int ------#
    #
    hybrid_int = int_literal
    hybrid_int = hybrid_int_literal
    hybrid_int = int
    hybrid_int = HybridInt(2,2)


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


    #------ hybrid_simd ------#
    #
    hybrid_simd = int_literal
    hybrid_simd = hybrid_int_literal
    hybrid_simd = float_literal
    hybrid_simd = hybrid_float_literal
    hybrid_simd = int
    hybrid_simd = hybrid_int
    hybrid_simd = float
    hybrid_simd = hybrid_float
    hybrid_simd = HybridSIMD[simd_type,simd_size].__init__(float,float)

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

    hybrid_simd.set_hybrid(0, hybrid_int_literal)


    #------ multiplex ------#
    #
    multiplex = Hyperplex64(1,1) + Complex64(1,1) + Paraplex64(1,1)

    multiplex = int_literal
    multiplex = hybrid_int_literal
    multiplex = float_literal
    multiplex = hybrid_float_literal
    multiplex = int
    multiplex = hybrid_int
    multiplex = float
    #multiplex = hybrid_float
    multiplex = simd
    multiplex = hybrid_simd
    
    multiplex = multiplex.__add__(Hyperplex64(1,1))
    multiplex = Hyperplex64(1,1) + multiplex

    multiplex = multiplex + Complex64(1,1)
    multiplex = Complex64(1,1) + multiplex

    multiplex = multiplex + Paraplex64(1,1)
    multiplex = Paraplex64(1,1) + multiplex

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


    #--- print (use math test instead though) ---#
    #
    # print(hybrid_int_literal.__str__())
    # print(hybrid_float_literal.__str__())
    # print(hybrid_int.__str__())
    # print(hybrid_float.__str__())
    # print()
    # print(hybrid_simd.__str__())
    # print(hybrid_simd[1][0])
    # print()
    # print(multiplex.__str__())
    # print()

    # to_unital is totally screwed with alias problems in current version, but i kept the non-idea simd.to_unital workaround because i need it to construct multiplex without constraining
    #var a: HybridSIMD[DType.float32,1,-1] = HybridSIMD[DType.float32,1,-2](0,3).unitize()
    #let a: HybridInt[-1] = HybridInt[-2](0,3).to_unital()
    #print(HybridIntLiteral[-2](0,3).to_unital().__str__())
    #print(HybridFloatLiteral[-2](0,3).to_unital().__str__())
    #print(HybridInt[-2](0,3).to_unital().__str__())
    # print(HybridSIMD[DType.float32,1,-2](0,3).to_unital().__str__())
    # print()


fn test_math():
    moprint()
    moprint("#------ Hybrid denomer and measure ------#")
    moprint()
    moprint("#--- Complex")
    print("0.25 ≈", Complex64(0.3000,  0.4).denomer())
    print("0.5  ≈", Complex64(0.3000,  0.4).measure())
    print("0.25 ≈", Complex64(-0.130, -0.482804308183).denomer())
    print("0.5  ≈", Complex64(-0.130, -0.482804308183).measure())
    print("4.0  ≈", Complex64(0.5000, -1.9364916731).denomer())
    print("2.0  ≈", Complex64(0.5000, -1.9364916731).measure())
    print("4.0  ≈", Complex64(-1.700,  1.05356537529).denomer())
    print("2.0  ≈", Complex64(-1.700,  1.05356537529).measure())
    print()
    print("#--- Paraplex")
    print("0.25 ≈", Paraplex64(-0.50,  0.75).denomer())
    print("0.5  ≈", Paraplex64(-0.50,  0.75).measure())
    print("4.0  ≈", Paraplex64(2.000,  10.0).denomer())
    print("2.0  ≈", Paraplex64(2.000,  10.0).measure())
    print("2.56 ≈", Paraplex64(-1.60, -4.00).denomer())
    print("1.6  ≈", Paraplex64(-1.60, -4.00).measure())
    print("0.01 ≈", Paraplex64(0.100,  0.00).denomer())
    print("0.1  ≈", Paraplex64(0.100,  0.00).measure())
    print()
    print("#--- Hyperplex")
    print("1 ≈", Hyperplex64(2.00,  1.7321).denomer())
    print("1 ≈", Hyperplex64(2.00,  1.7321).measure())
    print("1 ≈", Hyperplex64(1.20, -0.6633).denomer())
    print("1 ≈", Hyperplex64(1.20, -0.6633).measure())
    print("4 ≈", Hyperplex64(-3.0, -2.2360679775).denomer())
    print("2 ≈", Hyperplex64(-3.0, -2.2360679775).measure())
    print("4 ≈", Hyperplex64(-8.0, -7.74596669241).denomer())
    print("2 ≈", Hyperplex64(-8.0, -7.74596669241).measure())
    print()
    print("#--- Hybrid[-2]")
    print("4 ≈", HybridSIMD[DType.float64,1,-2](1.5,0.935414346693).denomer())
    print("2 ≈", HybridSIMD[DType.float64,1,-2](1.5,0.935414346693).measure())
    print()
    print("#--- Hybrid[0.5]")
    print("4 ≈", HybridSIMD[DType.float64,1,0.5](2.5,2.12132034356).denomer())
    print("2 ≈", HybridSIMD[DType.float64,1,0.5](2.5,2.12132034356).measure())
    print()
    print()
    print("#------ Hybrid min and max ------#")
    print()
    print("#--- Complex")
    print(min(Complex64(5,1).measure(), Complex64(9,-8).measure()),  "<",  max(Complex64(5,1).measure(), Complex64(9,-8).measure()))
    print(min(Complex64(5,1),           Complex64(9,-8)).__str__(),  "<",  max(Complex64(5,1),           Complex64(9,-8)).__str__())
    print()
    print("#--- Paraplex")
    print(min(Paraplex64(3,85).measure(), Paraplex64(6,-6).measure()),  "<",  max(Paraplex64(3,85).measure(), Paraplex64(6,-6).measure()))
    print(min(Paraplex64(3,85),           Paraplex64(6,-6)).__str__(),  "<",  max(Paraplex64(3,85),           Paraplex64(6,-6)).__str__())
    print()
    print("#--- Hyperplex")
    print(min(Hyperplex64(5,1).measure(), Hyperplex64(9,-8).measure()),  "<",  max(Hyperplex64(5,1).measure(), Hyperplex64(9,-8).measure()))
    print(min(Hyperplex64(5,1),           Hyperplex64(9,-8)).__str__(),  "<",  max(Hyperplex64(5,1),           Hyperplex64(9,-8)).__str__())
    print()
    print("#--- min_coef")
    print(HyperplexInt64(3,6).min_coef(), "<", HyperplexInt64(3,6).max_coef())
    print(HyperplexInt64(6,3).min_coef(), "<", HyperplexInt64(6,3).max_coef())
    print()
    print("#--- reduce_min & reduce_max")
    let reduce_1 = HybridSIMD[DType.float64,4,-1](    Complex64(2,3),     Complex64(3,1),     Complex64(4,1),     Complex64(5,1))
    let reduce_2 = HybridSIMD[DType.float64,4, 2](SuperHyperplex64(2,0), SuperHyperplex64(3,1), SuperHyperplex64(4,1), SuperHyperplex64(5,1))
    print(reduce_1.reduce_min().__str__(), "<", reduce_1.reduce_max().__str__())
    print(reduce_2.reduce_min().__str__(), "<", reduce_2.reduce_max().__str__())
    print()
    print("#--- reduce_min_compose & reduce_max_compose")
    print(reduce_1.reduce_min_compose().__str__(), "[<,<]", reduce_1.reduce_max_compose().__str__())
    print(reduce_2.reduce_min_compose().__str__(), "[<,<]", reduce_2.reduce_max_compose().__str__())
    print()
    print("#--- reduce_min_coef & reduce_max_coef")
    print(reduce_1.reduce_min_coef(), "<", reduce_1.reduce_max_coef())
    print(reduce_2.reduce_min_coef(), "<", reduce_2.reduce_max_coef())
    print()
    print()
    print("#------ Hybrid addition and subtraction ------#")
    print()
    print((Hyperplex64(1, 2) + Hyperplex64(2, 4) + 3).__str__(), "= 6.0 + 6.0x")
    print((10 - Hyperplex64(5, 5) - Hyperplex64(-1, 1)).__str__(), "= 6.0 - 6.0x")
    print()
    print()
    print("#------ Hybrid multiplication and division ------#")
    print()
    print("-4  =", (Complex64(0,2)*Complex64(0,2)).__str__())
    print(" 0  =", (Paraplex64(0,2)*Paraplex64(0,2)).__str__())
    print(" 4  = ",  (Hyperplex64(0,2)*Hyperplex64(0,2)).__str__())
    print("-3 + 4i  = ", (Complex64(1,2)*Complex64(1,2)).__str__())
    print("1 + 4o   = ", (Paraplex64(1,2)*Paraplex64(1,2)).__str__())
    print("5 + 4x   = ", (Hyperplex64(1,2)*Hyperplex64(1,2)).__str__())
    print("1.0  = ", (Complex64(1,-2)/Complex64(1,-2)).__str__())
    print("1.0  = ", (Paraplex64(1,-2)/Paraplex64(1,-2)).__str__())
    print("1.0  = ", (Hyperplex64(1,-2)/Hyperplex64(1,-2)).__str__())
    let div_complex = (Complex64(1,-2)/Complex64(-3,8))*Complex64(0,1)
    let div_paraplex = (Paraplex64(1,-2)/Paraplex64(-3,8))*Paraplex64(0,1)
    let div_hyperplex = (Hyperplex64(1,-2)/Hyperplex64(-3,8))*Hyperplex64(0,1)
    print(div_complex.__str__(), "that", div_paraplex.__str__(), "this", div_hyperplex.__str__(), "and lots of digits")
    print("i =  ", (div_complex*Complex64(-3,8)/Complex64(1,-2)).__str__())
    print("o =  ", (div_paraplex*Paraplex64(-3,8)/Paraplex64(1,-2)).__str__())
    print("x =  ", (div_hyperplex*Hyperplex64(-3,8)/Hyperplex64(1,-2)).__str__())
    print()
    print((HyperplexIntLiteral(1,2)*HyperplexIntLiteral(1,1)).__str__())
    print(HybridFloatLiteral[1](HyperplexIntLiteral(1,1)).__str__())
    print()
    print("0.0270820575 + 0.2927360563i = ", (Complex64(1,1)**Complex64(1,2)).__str__())
    print("-1 =  ", (Complex64(0,1)**2).__str__(), "=", (Complex64(0,1)**Complex64(2,0)).__str__())
    print(" 0 =  ", (Paraplex64(0,1)**2).__str__(), "=", (Paraplex64(0,1)**Paraplex64(2,0)).__str__())
    print(" 1 =  ", (Hyperplex64(0,1)**2).__str__(), "=", (Hyperplex64(0,1)**Hyperplex64(2,0)).__str__())
    print((Complex64(2,1)**2).__str__(), "=", (Complex64(2,1)**Complex64(2,0)).__str__(), "=", (Complex64(2,1)*Complex64(2,1)).__str__())
    print((Paraplex64(2,1)**2).__str__(), "=", (Paraplex64(2,1)**Paraplex64(2,0)).__str__(), "=", (Paraplex64(2,1)*Paraplex64(2,1)).__str__())
    print((Hyperplex64(2,1)**2).__str__(), "=", (Hyperplex64(2,1)**Hyperplex64(2,0)).__str__(), "=", (Hyperplex64(2,1)*Hyperplex64(2,1)).__str__())
    print("i =  ", (e**Complex64(0,hfpi)).__str__())
    print()
    print()
    print("#------ Multiplex ------#")
    print("3+i+o+x =  ", (Complex64(1,1) + Paraplex64(1,1) + Hyperplex64(1,1)).__str__())
    print("-1 =  ", (Multiplex64(0,1,0,0)*Multiplex64(0,1,0,0)).__str__())
    print(" 0 =  ", (Multiplex64(0,0,1,0)*Multiplex64(0,0,1,0)).__str__())
    print(" 1 =  ", (Multiplex64(0,0,0,1)*Multiplex64(0,0,0,1)).__str__())
    print(" 1 =  ", (Multiplex64(0,0,1,1)*Multiplex64(0,0,1,1)).__str__())
    let multiplex = Multiplex64(10,2,3,4) / Multiplex64(-4,3,2,1)
    print(multiplex.__str__())
    print("10 + 2i + 3o + 4x =  ", (multiplex*Multiplex64(-4,3,2,1)).__str__())

alias SuperHyperplex64 = HybridSIMD[DType.float64,1,2] # next gen game system