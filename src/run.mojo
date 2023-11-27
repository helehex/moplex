from sys import argv

fn main():
    from moplex.hybrid.test import test_math
    from example import example_code

    let command = argv()

    if len(command) > 1 and command[1] == "temp": temp()
    if len(command) == 1 or command[1] == "example": example_code()
    if len(command) == 1 or command[1] == "test_hybrid": test_math()
    



fn temp():
    print("temporary code")