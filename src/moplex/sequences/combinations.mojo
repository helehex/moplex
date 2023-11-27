from math import sqrt, log, exp, tgamma, lgamma

#------ lgamma ------#
# The lgamma functions compute the natural logarithm of the absolute value of gamma of x.
# A range error occurs if x is too large.
# A pole error may occur if x is a negative integer or zero.

#------ tgamma ------#
# The tgamma functions compute the gamma function of x.
# A domain error or pole error may occur if x is a negative integer or zero.
# A range error occurs if the magnitude of x is too large and may occur if the magnitude of x is too small.

#------ Factorial ------#
#
@always_inline
fn factorial_slow(n: Int) -> Float64:
    var result: Float64 = 0
    for i in range(2, n+1): result += log(Float64(i))
    return exp(result)

@always_inline
fn factorial_stirling(n: Float64) -> Float64:
    return sqrt(tau*n)*((n/e)**n)

@always_inline
fn factorial_gamma(n: Float64) -> Float64:
    return tgamma(n + 1.0)

@always_inline
fn factorial[n: IntLiteral]() -> IntLiteral:
    alias result: IntLiteral = factorial(n) # check: alias is probably unecessary, compiler can run at compile time regardless. maybe all these fn's are unecessary, but they do allow very explicit use.
    return result

@always_inline
fn factorial[n: Int]() -> Int:
    alias result: Int = factorial(n)
    return result

@always_inline
fn factorial(n: IntLiteral) -> IntLiteral:
    var result: IntLiteral = 1
    var i: IntLiteral = 2
    while i < n+1:
        result *= i
        i += 1
    return result

@always_inline
fn factorial(n: Int) -> Int:
    var result: Int = 1
    for i in range(2, n+1): result *= i
    return result


#------ Permutial ------#
#
# n! / (n-r)!
#
alias nPr: fn(Int,Int)->Int = permutial

@always_inline
fn permutial[n: IntLiteral, r: IntLiteral]() -> IntLiteral:
    alias result: IntLiteral = permutial(n, r)
    return result

@always_inline
fn permutial[n: Int, r: Int]() -> Int:
    alias result: Int = permutial(n, r)
    return result

@always_inline
fn permutial(n: IntLiteral, r: IntLiteral) -> IntLiteral:
    var i      : IntLiteral = n-r+1
    let end    : IntLiteral = n+1
    var result : IntLiteral = 1
    while i < end:
        result *= i
        i += 1
    return result

@always_inline
fn permutial[r: Int](n: Int) -> Int:
    alias start : Int = 1-r
    alias end   : Int = 1
    var result  : Int = 1
    @unroll
    for i in range(start, end): result *= n+i
    return result

@always_inline
fn permutial(n: Int, r: Int) -> Int:
    let start  : Int = n-r+1
    let end    : Int = n+1
    var result : Int = 1
    for i in range(start, end): result *= i
    return result


#------ Supertial ------#
#
# (d+n)! / n!
#
@always_inline
fn supertial[d: IntLiteral, n: IntLiteral]() -> IntLiteral:
    alias result: IntLiteral = supertial(d, n)
    return result

@always_inline
fn supertial[d: Int, n: Int]() -> Int:
    alias result: Int = supertial(d, n)
    return result

@always_inline
fn supertial(d: IntLiteral, n: IntLiteral) -> IntLiteral:
    var i      : IntLiteral = n+1
    let end    : IntLiteral = n+d+1
    var result : IntLiteral = 1
    while i < end:
        result *= i
        i += 1
    return result

@always_inline
fn supertial[d: Int](n: Int) -> Int:
    alias start : Int = 1
    alias end   : Int = d+1
    var result  : Int = 1
    @unroll
    for i in range(start, end): result *= n+i
    return result

@always_inline
fn supertial(d: Int, n: Int) -> Int:
    let start  : Int = n+1
    let end    : Int = n+d+1
    var result : Int = 1
    for i in range(start, end): result *= i
    return result


#------ Pascal ------#
#
# n! / (n-r)!r!
#
alias nCr: fn(Int,Int)->Int = pascal

@always_inline
fn pascal[n: IntLiteral, r: IntLiteral]() -> IntLiteral:
    alias result: IntLiteral = pascal(n, r)
    return result

@always_inline
fn pascal[n: Int, r: Int]() -> Int:
    alias result: Int = pascal(n, r)
    return result

@always_inline
fn pascal(n: IntLiteral, r: IntLiteral) -> IntLiteral:
    return permutial(n, r)//factorial(r)

@always_inline
fn pascal[n: Int](r: Int) -> Int:
    return permutial[n](r)//factorial(r)

@always_inline
fn pascal(n: Int, r: Int) -> Int:
    return permutial(n, r)//factorial(r)


#------ Simplicial ------#
#
# justified pascal
# (d+n)! / d!n!
#
# alias ntri = simplicial[2]  #  <--- parser crash
# alias ntet = simplicial[3]

@always_inline
fn simplicial[d: IntLiteral, n: IntLiteral]() -> IntLiteral:
    alias result: IntLiteral = simplicial(d, n)
    return result

@always_inline
fn simplicial[d: Int, n: Int]() -> Int:
    alias result: Int = simplicial(d, n)
    return result

@always_inline
fn simplicial(d: IntLiteral, n: IntLiteral) -> IntLiteral:
    return supertial(d, n)//factorial(d)

@always_inline
fn simplicial[d: Int](n: Int) -> Int:
    return supertial[d](n)//factorial(d)

@always_inline
fn simplicial(d: Int, n: Int) -> Int:
    return supertial(d, n)//factorial(d)