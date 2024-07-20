# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal
from _testing import assert_almost_equal

from moplex.math.limit import NAN, INF
from moplex.math.constants import e, pi
from moplex.hybrid.hybrid_simd import *


def main():
    test_is_zero()
    test_is_null()
    test_unitize()
    test_cast()
    test_str()
    test_getcoef()
    test_setcoef()
    test_getlane()
    test_setlane()
    test_denomer()
    test_measure()
    test_argument()
    test_min()
    test_max()
    test_min_coef()
    test_max_coef()
    test_reduce_min()
    test_reduce_max()
    test_reduce_min_compose()
    test_reduce_max_compose()
    test_reduce_min_coef()
    test_reduce_max_coef()
    test_add()
    test_sub()
    test_mul()
    test_truediv()
    # test_floordiv()
    test_pow()


def test_is_zero():
    # +--- [-1]
    assert_true(Complex64(0, 0).is_zero())
    assert_false(Complex64(1, 0).is_zero())
    assert_false(Complex64(0, 1).is_zero())
    assert_false(Complex64(1, 1).is_zero())

    # +--- [0]
    assert_true(Dualplex64(0, 0).is_zero())
    assert_false(Dualplex64(1, 0).is_zero())
    assert_false(Dualplex64(0, 1).is_zero())
    assert_false(Dualplex64(1, 1).is_zero())

    # +--- [1]
    assert_true(Hyperplex64(0, 0).is_zero())
    assert_false(Hyperplex64(1, 0).is_zero())
    assert_false(Hyperplex64(0, 1).is_zero())
    assert_false(Hyperplex64(1, 1).is_zero())


def test_is_null():
    # +--- [-1]
    assert_true(Complex64(0, 0).is_null())
    assert_false(Complex64(1, 0).is_null())
    assert_false(Complex64(0, 1).is_null())
    assert_false(Complex64(1, 1).is_null())

    # +--- [0]
    assert_true(Dualplex64(0, 0).is_null())
    assert_false(Dualplex64(1, 0).is_null())
    assert_true(Dualplex64(0, 1).is_null())
    assert_false(Dualplex64(1, 1).is_null())

    # +--- [1]
    assert_true(Hyperplex64(0, 0).is_null())
    assert_false(Hyperplex64(1, 0).is_null())
    assert_false(Hyperplex64(0, 1).is_null())
    assert_true(Hyperplex64(1, 1).is_null())


def test_unitize():
    assert_almost_equal(Hybrid64[-4](1, 2).unitize(), Complex64(1, 4))
    assert_almost_equal(Complex64(1, 2).unitize[-2](), Hybrid64[-2](1, 1.41421356237))


def test_cast():
    assert_equal(ComplexInt64(1, 2).cast[DType.float32](), Complex32(1, 2))
    assert_equal(Complex64(1, 2).cast[DType.int32](), ComplexInt32(1, 2))


def test_str():
    assert_equal(Complex64(1, 2).__str__(), "1.0 + 2.0i")
    assert_equal(Dualplex64(1, 2).__str__(), "1.0 + 2.0o")
    assert_equal(Hyperplex64(1, 2).__str__(), "1.0 + 2.0x")
    assert_equal(HybridSIMD[DType.float64, 1, -2](1, 2).__str__(), "1.0 + 2.0[-2.0]")
    assert_equal(HybridSIMD[DType.float64, 1, 0.5](1, 2).__str__(), "1.0 + 2.0[0.5]")


def test_getcoef():
    var h = Complex64(1, 2)
    assert_equal(h.getcoef(0), 1)
    assert_equal(h.getcoef(1), 2)


def test_setcoef():
    var h = Complex64(1, 2)
    h.setcoef(0, 9)
    assert_equal(h, Complex64(9, 2))
    h.setcoef(1, 8)
    assert_equal(h, Complex64(9, 8))


def test_getlane():
    var h = HybridSIMD[DType.float64, 4, -1]((1, 2), (3, 4), (5, 6), (7, 8))
    assert_equal(h.getlane(0), Complex64(1, 2))
    assert_equal(h.getlane(1), Complex64(3, 4))
    assert_equal(h.getlane(2), Complex64(5, 6))
    assert_equal(h.getlane(3), Complex64(7, 8))


def test_setlane():
    var h = HybridSIMD[DType.float64, 4, -1]((1, 2), (3, 4), (5, 6), (7, 8))
    h.setlane(0, Complex64(9, 8))
    assert_equal(h, HybridSIMD[DType.float64, 4, -1]((9, 8), (3, 4), (5, 6), (7, 8)))
    h.setlane(1, Complex64(7, 6))
    assert_equal(h, HybridSIMD[DType.float64, 4, -1]((9, 8), (7, 6), (5, 6), (7, 8)))
    h.setlane(2, Complex64(5, 4))
    assert_equal(h, HybridSIMD[DType.float64, 4, -1]((9, 8), (7, 6), (5, 4), (7, 8)))
    h.setlane(3, Complex64(3, 2))
    assert_equal(h, HybridSIMD[DType.float64, 4, -1]((9, 8), (7, 6), (5, 4), (3, 2)))


def test_denomer():
    # +--- [-1]
    assert_almost_equal(Complex64(0.3, 0.4).denomer(), 0.25)
    assert_almost_equal(Complex64(-0.13, -0.482804308183).denomer(), 0.25)
    assert_almost_equal(Complex64(0.5, -1.9364916731).denomer(), 4.0)
    assert_almost_equal(Complex64(-1.7, 1.05356537529).denomer(), 4.0)

    # +--- [0]
    assert_almost_equal(Dualplex64(-0.5, 0.75).denomer(), 0.25)
    assert_almost_equal(Dualplex64(2.0, 10.0).denomer(), 4.0)
    assert_almost_equal(Dualplex64(-1.6, -4.0).denomer(), 2.56)
    assert_almost_equal(Dualplex64(0.1, 0.0).denomer(), 0.01)
    
    # +--- [1]
    assert_almost_equal(Hyperplex64(2.0, 1.73205080757).denomer(), 1.0)
    assert_almost_equal(Hyperplex64(1.2, -0.663324958071).denomer(), 1.0)
    assert_almost_equal(Hyperplex64(-3.0, -2.2360679775).denomer(), 4.0)
    assert_almost_equal(Hyperplex64(-8.0, -7.74596669241).denomer(), 4.0)
    
    # +--- [-2]
    assert_almost_equal(HybridSIMD[DType.float64, 1, -2](1.5, 0.935414346693).denomer(), 4.0)
    
    # +--- [0.5]
    assert_almost_equal(HybridSIMD[DType.float64, 1, 0.5](2.5, 2.12132034356).denomer(), 4.0)


def test_measure():
    # +--- [-1]
    assert_almost_equal(Complex64(0.3, 0.4).measure(), 0.5)
    assert_almost_equal(Complex64(-0.13, -0.482804308183).measure(), 0.5)
    assert_almost_equal(Complex64(0.5, -1.9364916731).measure(), 2.0)
    assert_almost_equal(Complex64(-1.7, 1.05356537529).measure(), 2.0)

    # +--- [0]
    assert_almost_equal(Dualplex64(-0.5, 0.75).measure(), 0.5)
    assert_almost_equal(Dualplex64(2.0, 10.0).measure(), 2.0)
    assert_almost_equal(Dualplex64(-1.6, -4.0).measure(), 1.6)
    assert_almost_equal(Dualplex64(0.1, 0.0).measure(), 0.1)
    
    # +--- [1]
    assert_almost_equal(Hyperplex64(2.0, 1.73205080757).measure(), 1.0)
    assert_almost_equal(Hyperplex64(1.2, -0.663324958071).measure(), 1.0)
    assert_almost_equal(Hyperplex64(-3.0, -2.2360679775).measure(), 2.0)
    assert_almost_equal(Hyperplex64(-8.0, -7.74596669241).measure(), 2.0)
    
    # +--- [-2]
    assert_almost_equal(HybridSIMD[DType.float64, 1, -2](1.5, 0.935414346693).measure(), 2.0)
    
    # +--- [0.5]
    assert_almost_equal(HybridSIMD[DType.float64, 1, 0.5](2.5, 2.12132034356).measure(), 2.0)


def test_argument():
    # +--- [-1]
    assert_almost_equal(Complex64(0, 0).argument(), NAN, equal_nan=True)
    assert_almost_equal(Complex64(1, 0).argument(), 0)
    assert_almost_equal(Complex64(1, 1).argument(), pi / 4)
    assert_almost_equal(Complex64(0, 1).argument(), pi / 2)
    assert_almost_equal(Complex64(-1, 0).argument(), 0)
    assert_almost_equal(Complex64(0, -2).argument(), -pi / 2)
    assert_almost_equal(Complex64(1, 0).argument[branch=1](), pi)

    # +--- [0]
    assert_almost_equal(Dualplex64(0, 0).argument(), NAN, equal_nan=True)
    assert_almost_equal(Dualplex64(0, 1.5).argument(), INF)
    assert_almost_equal(Dualplex64(0, -3.1).argument(), -INF)
    assert_almost_equal(Dualplex64(6, 0).argument(), 0)
    assert_almost_equal(Dualplex64(-0.5, 0).argument(), 0)
    assert_almost_equal(Dualplex64(-2, -3).argument(), 1.5)
    assert_almost_equal(Dualplex64(-0.1, 0.1).argument(), -1.0)

    # +--- [1]
    assert_almost_equal(Hyperplex64(0, 0).argument(), NAN, equal_nan=True)
    assert_almost_equal(Hyperplex64(1, 1).argument(), INF)
    assert_almost_equal(Hyperplex64(2, -2).argument(), -INF)
    assert_almost_equal(Hyperplex64(5, 0).argument(), 0)
    assert_almost_equal(Hyperplex64(-0.1, 0).argument(), 0)
    assert_almost_equal(Hyperplex64(-3, -2).argument(), 0.804718956217)
    assert_almost_equal(Hyperplex64(-1, 0.1).argument(), -0.100335347731)


def test_min():
    # +--- [-1]
    assert_equal(Complex64(5, 1).min(Complex64(9, -8)), Complex64(5, 1))

    # +--- [0]
    assert_equal(Dualplex64(3, 85).min(Dualplex64(6, -6)), Dualplex64(3, 85))

    # +--- [1]
    assert_equal(Hyperplex64(5,1).min(Hyperplex64(9,-8)), Hyperplex64(9,-8))


def test_max():
    # +--- [-1]
    assert_equal(Complex64(5,1).max(Complex64(9,-8)), Complex64(9,-8))

    # +--- [0]
    assert_equal(Dualplex64(3,85).max(Dualplex64(6,-6)), Dualplex64(6,-6))

    # +--- [1]
    assert_equal(Hyperplex64(5,1).max(Hyperplex64(9,-8)), Hyperplex64(5,1))


def test_min_coef():
    assert_equal(Hyperplex64(3,6).min_coef(), 3)
    assert_equal(Hyperplex64(6,3).min_coef(), 3)


def test_max_coef():
    assert_equal(Hyperplex64(3,6).max_coef(), 6)
    assert_equal(Hyperplex64(6,3).max_coef(), 6)


def test_reduce_min():
    assert_equal(HybridSIMD[DType.float64, 4, -1]((2,3), (3,1), (4,5), (5,1)).reduce_min(), Complex64(3,1))
    assert_equal(HybridSIMD[DType.float64, 4, 0]((2,3), (3,1), (4,5), (5,1)).reduce_min(), Dualplex64(2,3))
    assert_equal(HybridSIMD[DType.float64, 4, 1]((2,3), (3,1), (4,5), (5,1)).reduce_min(), Hyperplex64(4,5))


def test_reduce_max():
    assert_equal(HybridSIMD[DType.float64, 4, -1]((2,3), (3,1), (4,5), (5,1)).reduce_max(), Complex64(4,5))
    assert_equal(HybridSIMD[DType.float64, 4, 0]((2,3), (3,1), (4,5), (5,1)).reduce_max(), Dualplex64(5,1))
    assert_equal(HybridSIMD[DType.float64, 4, 1]((2,3), (3,1), (4,5), (5,1)).reduce_max(), Hyperplex64(5,1))


def test_reduce_min_compose():
    assert_equal(HybridSIMD[DType.float64, 4, -1]((2,3), (3,1), (4,1), (5,1)).reduce_min_compose(), Complex64(2, 1))


def test_reduce_max_compose():
    assert_equal(HybridSIMD[DType.float64, 4, -1]((2,3), (3,1), (4,1), (5,1)).reduce_max_compose(), Complex64(5, 3))


def test_reduce_min_coef():
    assert_equal(HybridSIMD[DType.float64, 4, -1]((2,3), (3,1), (4,1), (5,1)).reduce_min_coef(), 1)


def test_reduce_max_coef():
    assert_equal(HybridSIMD[DType.float64, 4, -1]((2,3), (3,1), (4,1), (5,1)).reduce_max_coef(), 5)


def test_add():
    assert_equal(Complex64(1, 2) + Complex64(2, 4) + 3, Complex64(6.0, 6.0))
    assert_equal(Dualplex64(1, 2) + Dualplex64(2, 4) + 3, Dualplex64(6.0, 6.0))
    assert_equal(Hyperplex64(1, 2) + Hyperplex64(2, 4) + 3, Hyperplex64(6.0, 6.0))


def test_sub():
    assert_equal(10 - Complex64(5, 5) - Complex64(-1, 1), Complex64(6.0, -6.0))
    assert_equal(10 - Dualplex64(5, 5) - Dualplex64(-1, 1), Dualplex64(6.0, -6.0))
    assert_equal(10 - Hyperplex64(5, 5) - Hyperplex64(-1, 1), Hyperplex64(6.0, -6.0))


def test_mul():
    # +--- [-1]
    assert_equal(Complex64(0, 0) * Complex64(1, 2), Complex64(0, 0))
    assert_equal(Complex64(1, 0) * Complex64(1, 2), Complex64(1, 2))
    assert_equal(Complex64(0, 2) * Complex64(0, 2), Complex64(-4, 0))
    assert_equal(Complex64(1, 2) * Complex64(1, 2), Complex64(-3, 4))
    
    # +--- [0]
    assert_equal(Dualplex64(0, 0) * Dualplex64(1, 2), Dualplex64(0, 0))
    assert_equal(Dualplex64(1, 0) * Dualplex64(1, 2), Dualplex64(1, 2))
    assert_equal(Dualplex64(0, 2) * Dualplex64(0, 2), Dualplex64(0, 0))
    assert_equal(Dualplex64(1, 2) * Dualplex64(1, 2), Dualplex64(1, 4))
    
    # +--- [1]
    assert_equal(Hyperplex64(0, 0) * Hyperplex64(1, 2), Hyperplex64(0, 0))
    assert_equal(Hyperplex64(1, 0) * Hyperplex64(1, 2), Hyperplex64(1, 2))
    assert_equal(Hyperplex64(0, 2) * Hyperplex64(0, 2), Hyperplex64(4, 0))
    assert_equal(Hyperplex64(1, 2) * Hyperplex64(1, 2), Hyperplex64(5, 4))


def test_truediv():
    # +--- [-1]
    assert_equal(Complex64(0, 0) / Complex64(1, 2), Complex64(0, 0))
    assert_equal(Complex64(1, 2) / Complex64(1, 2), Complex64(1, 0))
    assert_equal(Complex64(-4, 0) / Complex64(0, 2), Complex64(0, 2))
    assert_equal(Complex64(-3, 4) / Complex64(1, 2), Complex64(1, 2))

    # +--- [0]
    assert_equal(Dualplex64(0, 0) / Dualplex64(1, 2), Dualplex64(0, 0))
    assert_equal(Dualplex64(1, 2) / Dualplex64(1, 2), Dualplex64(1, 0))
    assert_equal(Dualplex64(0, 0) / Dualplex64(0, 2), Dualplex64(NAN, NAN))
    assert_equal(Dualplex64(1, 4) / Dualplex64(1, 2), Dualplex64(1, 2))

    # +--- [1]
    assert_equal(Hyperplex64(0, 0) / Hyperplex64(1, 2), Hyperplex64(0, 0))
    assert_equal(Hyperplex64(1, 2) / Hyperplex64(1, 2), Hyperplex64(1, 0))
    assert_equal(Hyperplex64(4, 0) / Hyperplex64(0, 2), Hyperplex64(0, 2))
    assert_equal(Hyperplex64(5, 4) / Hyperplex64(1, 2), Hyperplex64(1, 2))


def test_pow():
    # +--- [-1]
    assert_almost_equal(e ** Complex64(0, pi), Complex64(-1, 0))
    assert_almost_equal(e ** Complex64(0, pi/2), Complex64(0, 1))
    assert_almost_equal(Complex64(1, 1) ** Complex64(1, 2), Complex64(0.0270820575, 0.2927360563))
    assert_almost_equal(Complex64(0, 1) ** 2, Complex64(-1, 0))
    assert_almost_equal(Complex64(0, 1) ** Complex64(2, 0), Complex64(-1, 0))
    assert_almost_equal(Complex64(2, 1) ** 2, Complex64(3, 4))
    assert_almost_equal(Complex64(2, 1) ** Complex64(2,0), Complex64(3, 4))

    # +--- [0]
    assert_almost_equal(Dualplex64(0, 1) ** 2, Dualplex64(0, 0))

    # TODO: fix Dualplex**Dualplex degeneracy
    # assert_almost_equal(Dualplex64(0, 1) ** Dualplex64(2,0), Dualplex64(0, 0))

    assert_almost_equal(Dualplex64(2, 1) ** 2, Dualplex64(4, 4))
    assert_almost_equal(Dualplex64(2, 1) ** Dualplex64(2, 0), Dualplex64(4, 4))

    # +--- [1]
    assert_almost_equal(Hyperplex64(0, 1) ** 2, Hyperplex64(1, 0))
    assert_almost_equal(Hyperplex64(0, 1) ** Hyperplex64(2, 0), Hyperplex64(1, 0))
    assert_almost_equal(Hyperplex64(2,1) ** 2, Hyperplex64(5,4))
    assert_almost_equal(Hyperplex64(2,1) ** Hyperplex64(2,0), Hyperplex64(5,4))