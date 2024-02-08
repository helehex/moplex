from sys import argv
from moplex.hybrid.test import test_math
from example import example_code

fn main():
    var command = argv()

    if len(command) > 1 and command[1] == "temp": temp()
    if len(command) == 1 or command[1] == "example": example_code()
    if len(command) == 1 or command[1] == "test": test_math()
    


from moplex.hybrid import HybridInt
fn temp():
    print("temporary code")
    var a = HybridInt[2](1,2)
    var b = HybridInt[2](2,1)
    print((a * b).to_unital())
    print(a.to_unital() * b.to_unital())