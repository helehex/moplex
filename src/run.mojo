from sys import argv
from moplex.hybrid.test import test_math
from example import example_code
from bench import bench

fn main():
    var command = argv()

    if len(command) > 1 and command[1] == "temp": temp()
    if len(command) > 1 and command[1] == "bench": bench()
    if len(command) == 1 or command[1] == "example": example_code()
    if len(command) == 1 or command[1] == "test": test_math()
    


from moplex import HybridInt, HybridSIMD
from moplex.random import rand, random_frac, random_sign
from moplex.math import sin, expa
from math import copysign

fn temp():
    print("temp code:\n")
    #print(rand[DType.float32,8,1]())
    # var a = random_frac[DType.float32,16,-1]()
    # print(a)
    # print(a.measure())

    var count: Int = 0
    var amount: Int = 1000
    for i in range(amount):
        if random_frac[DType.float64,1,1]().measure() > 0.5: count += 1
    print(count, " / ", amount)