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

    # find better way to handle imaginary measure on hyperplex numbers. pow behaves badly

    print("temp\n")
    var on = SIMD[DType.float64,1](0)
    var no = SIMD[DType.float64,1](1)
    var sq = SIMD[DType.float64,1](2)

    print(Complex64(0,1)**on, "= 1")
    print(Complex64(0,1)**no, "= 1i")
    print(Complex64(0,1)**sq, "= -1")
    print(Paraplex64(0,1)**on, "= 1")
    print(Paraplex64(0,1)**no, "= 1o")
    print(Paraplex64(0,1)**sq, "= 0")
    print(Hyperplex64(0,1)**on, "= 1")
    print(Hyperplex64(0,1)**no, "= 1x")
    print(Hyperplex64(0,1)**sq, "= 1")