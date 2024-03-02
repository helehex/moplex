from sys import argv
from test import test_math
from example import example_code
from bench import bench_hybrid, bench_multiplex

fn main():
    var command = argv()

    if len(command) > 1 and command[1] == "temp": temp()
    if len(command) > 1 and command[1] == "bench": bench_hybrid()
    if len(command) == 1 or command[1] == "example": example_code()
    if len(command) == 1 or command[1] == "test": test_math()



from moplex.hybrid import *
from moplex.random import *
from moplex.math import *


fn temp():
    print("temp\n")

    #--- test ctime simd sqrt

    # only works for simd size = 1 when aliased
    # lucky i only need it for that

    # var s = sqrt(SIMD[DType.float64,8](-1,0,0.5,4,5,6,7,8))
    # var s = sqrt[DType.int64, 8, SIMD[DType.int64,8](-1,0,1,4,9,16,18,25)]()
    # alias s = sqrt[DType.float64, 1, SIMD[DType.float64,1](2)]()
    # print(s)
    # print(s*s)

    var a = HybridSIMD[DType.float64,8,-1]((1,1), (2,2), (1,10), (1,-8), (-2,-3), (4,5), (6,7), (8,9))
    print(a)
    print()
    print(a.reduce_add())
    print(a.reduce_mul())
    print(a.reduce_min())
    print(a.reduce_max())
    print()
    print(max(HybridSIMD[DType.float64,1,-1](1,2), nan_hybrid[DType.float64, -1]()))
    print(max(nan_hybrid[DType.float64, -1](), HybridSIMD[DType.float64,1,-1](1,2)))
    print()


    #--- test lambert w
    print(lw(HybridSIMD[DType.float64,1,-1](1)))
    print()


    #--- nil
    print(HybridSIMD[DType.float64,1,1](0,0).nil())
    print(HybridSIMD[DType.float64,1,1](1,0).nil())
    print(HybridSIMD[DType.float64,1,1](0,1).nil())
    print(HybridSIMD[DType.float64,1,1](-1,-1).nil())


    #--- math.limit
    # print(sqrt(1.2))
    # print(nan_hybrid[DType.float64,-1,4]())
    # alias b = isnan(Nan)
    # print(b)

    # #this fails
    # @parameter
    # if isnan(Float64(Nan)):
    #     print("G")


    #--- test casting between antiox
    # print()
    # var a = HybridSIMD[DType.float64,2,-2](2,3)
    # print(a.to_unital()*a.to_unital())
    # print((a*a).to_unital())
    # print()
    # print(a*a)
    # print((a.cast[DType.float16,-3]()*a.cast[DType.float16,-3]()).cast[DType.float64,-2]())
    # print()
    # var casted: HybridSIMD[DType.float32,2,1] = 0
    # print(a.try_cast[DType.float32,1](casted), casted)
    # print()


    # #--- test get and set antiox
    # var m = HybridSIMD[DType.float64,1,-0.5](10,6)
    # m.set_antiox[-2](6)
    # print(m.get_antiox[-2]())
    # var n = HybridSIMD[DType.float64,1,-2](10,6)
    # print(m)
    # print(n.cast[target_square = -0.5]())


    #--- find better way to handle imaginary measure on hyperplex numbers. pow behaves badly

    # print(pow[branch=4](HybridSIMD[DType.float64,1,-1](1), 1/4))
    
    # var on = SIMD[DType.float64,1](0)
    # var no = SIMD[DType.float64,1](1)
    # var sq = SIMD[DType.float64,1](2)

    # print(Complex64(0,1)**on, "= 1")
    # print(Complex64(0,1)**no, "= 1i")
    # print(Complex64(0,1)**sq, "= -1")
    # print(Paraplex64(0,1)**on, "= 1")
    # print(Paraplex64(0,1)**no, "= 1o")
    # print(Paraplex64(0,1)**sq, "= 0")
    # print(Hyperplex64(0,1)**on, "= 1")
    # print(Hyperplex64(0,1)**no, "= 1x")
    # print(Hyperplex64(0,1)**sq, "= 1")