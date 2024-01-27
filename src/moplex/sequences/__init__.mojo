from .combinations import *
from .constants import *




#------ Recurrent ------#
#

#alias fibonacci = recurrent[Int,add, df_n0 = 0, df_n1 = 1]

fn fibonacci[n0: Int = 0, n1: Int = 1](iterations: Int) -> Int:
    return recurrent[Int,add,n0,n1](iterations)

@always_inline("nodebug")
fn add(a: Int, b: Int) -> Int: return a+b

@always_inline("nodebug")
fn recurrent[T: AnyRegType, func: fn(T,T)->T, default_n0: T, default_n1: T](iterations: Int, n0: T = default_n0, n1: T = default_n1) -> T:
    var _n0: T = n0
    var _n1: T = n1
    for i in range(iterations):
        let _n2: T = func(_n0, _n1)
        _n0 = _n1
        _n1 = _n2
    return _n1

# # ghost crash
# @always_inline("nodebug")
# fn recurrent[T: AnyType, func: fn(T,T)->T, df_n0: T, df_n1: T, n0: T = df_n0, n1: T = df_n1](iterations: Int) -> T:
#     var _n0: T = n0
#     var _n1: T = n1
#     for i in range(iterations):
#         let _n2: T = func(_n0, _n1)
#         _n0 = _n1
#         _n1 = _n2
#     return _n1


#------ Prime ------#
#

#------ Mersenne ------#
#

#------ Divisor ------#
#
@always_inline
fn gcd(a: IntLiteral, b: IntLiteral) -> IntLiteral:
    var _a: IntLiteral = a
    var _b: IntLiteral = b
    while _b != 0:
        let _c: IntLiteral = _a % _b
        _a = _b
        _b = _c
    return _a