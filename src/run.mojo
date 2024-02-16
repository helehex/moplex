from sys import argv
from moplex.hybrid.test import test_math
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

    # test lambert w function. works good, but still needs work, branch selection etc..
    let h = HybridSIMD[DType.float64,1,-1](10, 5)
    let lwh = lw(h)
    print(lwh)
    print(lwh*exp(lwh))

    # print(expa[square = -0.5](SIMD[DType.float64,1](tau/4)))
    # print(cot(HybridSIMD[DType.float64,1,-1](tau,0)))
    # print("temp code:\n")
    # var a = HybridSIMD[DType.float64,1,-1](-10,5)
    # print(a, ",", a.argument())
    # a = a.normalized()
    # print(a, ",", a.argument())
    # print(a.measure())