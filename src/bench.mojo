from moplex.random import random_frac
from moplex import HybridSIMD
import benchmark

fn bench():
    alias type: DType = DType.float32

    var a1 = random_frac[type,1,1]()
    var b1 = random_frac[type,1,1]()

    var a2 = random_frac[type,2,1]()
    var b2 = random_frac[type,2,1]()

    var a4 = random_frac[type,4,1]()
    var b4 = random_frac[type,4,1]()

    var a8 = random_frac[type,8,1]()
    var b8 = random_frac[type,8,1]()

    var a16 = random_frac[type,16,1]()
    var b16 = random_frac[type,16,1]()

    @parameter
    fn f1():
        var o = a1*b1*(a1 + b1)
        benchmark.keep(o)

    @parameter
    fn f2():
        var o = a2*b2*(a2 + b2)
        benchmark.keep(o)

    @parameter
    fn f4():
        var o = a4*b4*(a4 + b4)
        benchmark.keep(o)

    @parameter
    fn f8():
        var o = a8*b8*(a8 + b8)
        benchmark.keep(o)

    @parameter
    fn f16():
        var o = a16*b16*(a16 + b16)
        benchmark.keep(o)

    print()
    print("width: ", simdwidthof[type]())
    print()
    print("1 : ", benchmark.run[f1]().mean("ns"))
    print("2 : ", benchmark.run[f2]().mean("ns"))
    print("4 : ", benchmark.run[f4]().mean("ns"))
    print("8 : ", benchmark.run[f8]().mean("ns"))
    print("16 : ", benchmark.run[f16]().mean("ns"))