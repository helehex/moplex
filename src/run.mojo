from sys import argv
from moplex.hybrid.test import test_math
from example import example_code
from bench import bench_hybrid, bench_multiplex

fn main():
    var command = argv()

    if len(command) > 1 and command[1] == "temp": temp()
    if len(command) > 1 and command[1] == "bench": bench_multiplex()
    if len(command) == 1 or command[1] == "example": example_code()
    if len(command) == 1 or command[1] == "test": test_math()
    


from moplex import HybridIntLiteral, HybridFloatLiteral, HybridInt, HybridSIMD
from moplex.random import rand, random_frac, random_sign
from moplex.math import sin, expa
from math import copysign

fn temp():
    print("temp code:\n")
    var a = HybridSIMD[DType.float64,1,-1](-10,5)
    print(a, ",", a.argument())
    a = a.normalized()
    print(a, ",", a.argument())
    print(a.measure())