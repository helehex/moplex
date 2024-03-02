#------( NaN )------#
#
from math.math import nan as _nan
from math.math import isnan as _isnan

alias Nan: FloatLiteral = __mlir_attr.`0x7ff8000000000000:f64`


@always_inline
fn nan[type: DType, size: Int = 1, fail: Optional[SIMD[type,1]] = None]() -> SIMD[type,size]:
    @parameter
    if type.is_floating_point(): return _nan[type]()
    constrained[fail.__bool__(), "cannot get nan of integral dtype"]()
    return fail.value()

@always_inline
fn nan_hybrid[type: DType, square: SIMD[type,1], size: Int = 1, fail: Optional[HybridSIMD[type,1,square]] = None]() -> HybridSIMD[type,size,square]:
    @parameter
    if type.is_floating_point(): return (_nan[type](), _nan[type]())
    constrained[fail.__bool__(), "cannot get nan of integral dtype"]()
    return fail.value()

@always_inline
fn nan_multiplex[type: DType, size: Int = 1, fail: Optional[MultiplexSIMD[type,1]] = None]() -> MultiplexSIMD[type,size]:
    @parameter
    if type.is_floating_point(): return MultiplexSIMD[type,1](_nan[type](), _nan[type](), _nan[type](), _nan[type]())
    constrained[fail.__bool__(), "cannot get nan of integral dtype"]()
    return fail.value()

@always_inline
fn isnan(value: FloatLiteral) -> Bool:
    return value != value

@always_inline
fn isnan(value: SIMD) -> SIMD[DType.bool,value.size]:
    return _isnan(value)

@always_inline
fn isnan_hybrid[type: DType, size: Int, square: Scalar[type]](value: HybridSIMD[type,size,square]) -> SIMD[DType.bool, size]:
    return _isnan(value.s) or _isnan(value.a)

@always_inline
fn isnan_multiplex(value: MultiplexSIMD) -> SIMD[DType.bool, value.size]:
    return _isnan(value.s) or _isnan(value.i) or _isnan(value.o) or _isnan(value.x)