# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal
from _testing import assert_almost_equal

from moplex.math.limit import NAN, INF
from moplex.math.constants import e, pi
from moplex.hybrid.hybrid_int import *


def main():
    test_is_zero()
    test_is_null()
    test_unitize()
    test_str()
    test_getcoef()
    test_setcoef()
    test_denomer()
    test_measure()
    test_argument()
    test_min()
    test_max()
    test_add()
    test_sub()
    test_mul()
    test_truediv()
    # test_floordiv()
    test_pow()


def test_is_zero():
    # +--- [-1]
    assert_true(ComplexInt(0, 0).is_zero())
    assert_false(ComplexInt(1, 0).is_zero())
    assert_false(ComplexInt(0, 1).is_zero())
    assert_false(ComplexInt(1, 1).is_zero())

    # +--- [0]
    assert_true(DualplexInt(0, 0).is_zero())
    assert_false(DualplexInt(1, 0).is_zero())
    assert_false(DualplexInt(0, 1).is_zero())
    assert_false(DualplexInt(1, 1).is_zero())

    # +--- [1]
    assert_true(HyperplexInt(0, 0).is_zero())
    assert_false(HyperplexInt(1, 0).is_zero())
    assert_false(HyperplexInt(0, 1).is_zero())
    assert_false(HyperplexInt(1, 1).is_zero())


def test_is_null():
    # +--- [-1]
    assert_true(ComplexInt(0, 0).is_null())
    assert_false(ComplexInt(1, 0).is_null())
    assert_false(ComplexInt(0, 1).is_null())
    assert_false(ComplexInt(1, 1).is_null())

    # +--- [0]
    assert_true(DualplexInt(0, 0).is_null())
    assert_false(DualplexInt(1, 0).is_null())
    assert_true(DualplexInt(0, 1).is_null())
    assert_false(DualplexInt(1, 1).is_null())

    # +--- [1]
    assert_true(HyperplexInt(0, 0).is_null())
    assert_false(HyperplexInt(1, 0).is_null())
    assert_false(HyperplexInt(0, 1).is_null())
    assert_true(HyperplexInt(1, 1).is_null())


def test_unitize():
    from moplex import Complex64
    assert_almost_equal(HybridInt[-4](1, 2).unitize(), Complex64(1, 4))


def test_str():
    assert_equal(ComplexInt(1, 2).__str__(), "1 + 2i")
    assert_equal(DualplexInt(1, 2).__str__(), "1 + 2o")
    assert_equal(HyperplexInt(1, 2).__str__(), "1 + 2x")
    assert_equal(HybridInt[-2](1, 2).__str__(), "1 + 2[-2]")
    assert_equal(HybridInt[3](1, 2).__str__(), "1 + 2[3]")


def test_getcoef():
    var h = ComplexInt(1, 2)
    assert_equal(h.getcoef(0), 1)
    assert_equal(h.getcoef(1), 2)


def test_setcoef():
    var h = ComplexInt(1, 2)
    h.setcoef(0, 9)
    assert_equal(h, ComplexInt(9, 2))
    h.setcoef(1, 8)
    assert_equal(h, ComplexInt(9, 8))


def test_denomer():
    # +--- [-1]
    assert_almost_equal(ComplexInt(1, 1).denomer(), 2.0)
    assert_almost_equal(ComplexInt(3, -4).denomer(), 25.0)
    assert_almost_equal(ComplexInt(-5, 2).denomer(), 29.0)
    assert_almost_equal(ComplexInt(-0, -6).denomer(), 36.0)

    # +--- [0]
    assert_almost_equal(DualplexInt(-1, 1).denomer(), 1.0)
    assert_almost_equal(DualplexInt(0, 9).denomer(), 0.0)
    assert_almost_equal(DualplexInt(-2, -4).denomer(), 4.0)
    assert_almost_equal(DualplexInt(3, 0).denomer(), 9.0)
    
    # +--- [1]
    assert_almost_equal(HyperplexInt(2, 1).denomer(), 3.0)
    assert_almost_equal(HyperplexInt(1, -6).denomer(), -35.0)
    assert_almost_equal(HyperplexInt(-3, 2).denomer(), 5.0)
    assert_almost_equal(HyperplexInt(-8, -7).denomer(), 15.0)
    
    # +--- [-2]
    assert_almost_equal(HybridInt[-2](1, 2).denomer(), 9.0)
    
    # +--- [3]
    assert_almost_equal(HybridInt[3](1, 2).denomer(), -11.0)


def test_measure():
    # +--- [-1]
    assert_almost_equal(ComplexInt(1, 1).measure(), 1.4142135623)
    assert_almost_equal(ComplexInt(3, -4).measure(), 5.0)
    assert_almost_equal(ComplexInt(-5, 12).measure(), 13.0)
    assert_almost_equal(ComplexInt(-8, -15).measure(), 17.0)

    # +--- [0]
    assert_almost_equal(DualplexInt(-1, 1).measure(), 1.0)
    assert_almost_equal(DualplexInt(0, 8).measure(), 0.0)
    assert_almost_equal(DualplexInt(-2, -5).measure(), 2.0)
    assert_almost_equal(DualplexInt(3, 0).measure(), 3.0)

    # +--- [1]
    assert_almost_equal(HyperplexInt(5, 4).measure(), 3.0)
    assert_almost_equal(HyperplexInt(6, -6).measure(), 0.0)
    assert_almost_equal(HyperplexInt(-4, 2).measure(), 3.46410161514)
    assert_almost_equal(HyperplexInt(-8, -7).measure(), 3.87298334621)
    
    # +--- [-2]
    assert_almost_equal(HybridInt[-2](2, 1).measure(), 2.44948974278)
    
    # +--- [3]
    assert_almost_equal(HybridInt[3](2, 1).measure(), 1.0)


def test_argument():
    # +--- [-1]
    assert_almost_equal(ComplexInt(0, 0).argument(), NAN, equal_nan=True)
    assert_almost_equal(ComplexInt(1, 0).argument(), 0)
    assert_almost_equal(ComplexInt(1, 1).argument(), pi / 4)
    assert_almost_equal(ComplexInt(0, 1).argument(), pi / 2)
    assert_almost_equal(ComplexInt(-1, 0).argument(), 0)
    assert_almost_equal(ComplexInt(0, -2).argument(), -pi / 2)
    assert_almost_equal(ComplexInt(1, 0).argument[branch=1](), pi)

    # +--- [0]
    assert_almost_equal(DualplexInt(0, 0).argument(), NAN, equal_nan=True)
    assert_almost_equal(DualplexInt(0, 2).argument(), INF)
    assert_almost_equal(DualplexInt(0, -3).argument(), -INF)
    assert_almost_equal(DualplexInt(6, 0).argument(), 0)
    assert_almost_equal(DualplexInt(-1, 0).argument(), 0)
    assert_almost_equal(DualplexInt(-2, -3).argument(), 1.5)
    assert_almost_equal(DualplexInt(-1, 1).argument(), -1.0)

    # +--- [1]
    assert_almost_equal(HyperplexInt(0, 0).argument(), NAN, equal_nan=True)
    assert_almost_equal(HyperplexInt(1, 1).argument(), INF)
    assert_almost_equal(HyperplexInt(2, -2).argument(), -INF)
    assert_almost_equal(HyperplexInt(5, 0).argument(), 0)
    assert_almost_equal(HyperplexInt(-1, 0).argument(), 0)
    assert_almost_equal(HyperplexInt(-3, -2).argument(), 0.804718956217)


def test_min():
    # +--- [-1]
    assert_equal(ComplexInt(5, 1).min(ComplexInt(9, -8)), ComplexInt(5, 1))

    # +--- [0]
    assert_equal(DualplexInt(3, 85).min(DualplexInt(6, -6)), DualplexInt(3, 85))

    # +--- [1]
    assert_equal(HyperplexInt(5,1).min(HyperplexInt(9,-8)), HyperplexInt(9,-8))


def test_max():
    # +--- [-1]
    assert_equal(ComplexInt(5,1).max(ComplexInt(9,-8)), ComplexInt(9,-8))

    # +--- [0]
    assert_equal(DualplexInt(3,85).max(DualplexInt(6,-6)), DualplexInt(6,-6))

    # +--- [1]
    assert_equal(HyperplexInt(5,1).max(HyperplexInt(9,-8)), HyperplexInt(5,1))


def test_add():
    assert_equal(ComplexInt(1, 2) + ComplexInt(2, 4) + 3, ComplexInt(6, 6))
    assert_equal(DualplexInt(1, 2) + DualplexInt(2, 4) + 3, DualplexInt(6, 6))
    assert_equal(HyperplexInt(1, 2) + HyperplexInt(2, 4) + 3, HyperplexInt(6, 6))


def test_sub():
    assert_equal(10 - ComplexInt(5, 5) - ComplexInt(-1, 1), ComplexInt(6, -6))
    assert_equal(10 - DualplexInt(5, 5) - DualplexInt(-1, 1), DualplexInt(6, -6))
    assert_equal(10 - HyperplexInt(5, 5) - HyperplexInt(-1, 1), HyperplexInt(6, -6))


def test_mul():
    # +--- [-1]
    assert_equal(ComplexInt(0, 0) * ComplexInt(1, 2), ComplexInt(0, 0))
    assert_equal(ComplexInt(1, 0) * ComplexInt(1, 2), ComplexInt(1, 2))
    assert_equal(ComplexInt(0, 2) * ComplexInt(0, 2), ComplexInt(-4, 0))
    assert_equal(ComplexInt(1, 2) * ComplexInt(1, 2), ComplexInt(-3, 4))
    
    # +--- [0]
    assert_equal(DualplexInt(0, 0) * DualplexInt(1, 2), DualplexInt(0, 0))
    assert_equal(DualplexInt(1, 0) * DualplexInt(1, 2), DualplexInt(1, 2))
    assert_equal(DualplexInt(0, 2) * DualplexInt(0, 2), DualplexInt(0, 0))
    assert_equal(DualplexInt(1, 2) * DualplexInt(1, 2), DualplexInt(1, 4))
    
    # +--- [1]
    assert_equal(HyperplexInt(0, 0) * HyperplexInt(1, 2), HyperplexInt(0, 0))
    assert_equal(HyperplexInt(1, 0) * HyperplexInt(1, 2), HyperplexInt(1, 2))
    assert_equal(HyperplexInt(0, 2) * HyperplexInt(0, 2), HyperplexInt(4, 0))
    assert_equal(HyperplexInt(1, 2) * HyperplexInt(1, 2), HyperplexInt(5, 4))


def test_truediv():
    from moplex import Complex64, Dualplex64, Hyperplex64

    # +--- [-1]
    assert_equal(ComplexInt(0, 0) / ComplexInt(1, 2), Complex64(0, 0))
    assert_equal(ComplexInt(1, 2) / ComplexInt(1, 2), Complex64(1, 0))
    assert_equal(ComplexInt(-4, 0) / ComplexInt(0, 2), Complex64(0, 2))
    assert_equal(ComplexInt(-3, 4) / ComplexInt(1, 2), Complex64(1, 2))

    # +--- [0]
    assert_equal(DualplexInt(0, 0) / DualplexInt(1, 2), Dualplex64(0, 0))
    assert_equal(DualplexInt(1, 2) / DualplexInt(1, 2), Dualplex64(1, 0))
    assert_equal(DualplexInt(0, 0) / DualplexInt(0, 2), Dualplex64(NAN, NAN))
    assert_equal(DualplexInt(1, 4) / DualplexInt(1, 2), Dualplex64(1, 2))

    # +--- [1]
    assert_equal(HyperplexInt(0, 0) / HyperplexInt(1, 2), Hyperplex64(0, 0))
    assert_equal(HyperplexInt(1, 2) / HyperplexInt(1, 2), Hyperplex64(1, 0))
    assert_equal(HyperplexInt(4, 0) / HyperplexInt(0, 2), Hyperplex64(0, 2))
    assert_equal(HyperplexInt(5, 4) / HyperplexInt(1, 2), Hyperplex64(1, 2))


def test_pow():
    from moplex import Complex64, Dualplex64, Hyperplex64

    # +--- [-1]
    assert_almost_equal(1 ** ComplexInt(0, 1), Complex64(1, 0))
    assert_almost_equal(2 ** ComplexInt(0, 1), Complex64(0.7692389013, 0.6389612763))
    assert_almost_equal(ComplexInt(1, 1) ** ComplexInt(1, 2), Complex64(0.0270820575, 0.2927360563))
    assert_almost_equal(ComplexInt(0, 1) ** 2, Complex64(-1, 0))
    assert_almost_equal(ComplexInt(0, 1) ** ComplexInt(2, 0), Complex64(-1, 0))
    assert_almost_equal(ComplexInt(2, 1) ** 2, Complex64(3, 4))
    assert_almost_equal(ComplexInt(2, 1) ** ComplexInt(2,0), Complex64(3, 4))

    # +--- [0]
    assert_almost_equal(DualplexInt(0, 1) ** 2, Dualplex64(0, 0))

    # TODO: fix Dualplex**Dualplex degeneracy
    # assert_almost_equal(DualplexInt(0, 1) ** DualplexInt(2,0), Dualplex64(0, 0))

    assert_almost_equal(DualplexInt(2, 1) ** 2, Dualplex64(4, 4))
    assert_almost_equal(DualplexInt(2, 1) ** DualplexInt(2, 0), Dualplex64(4, 4))

    # +--- [1]
    assert_almost_equal(HyperplexInt(0, 1) ** 2, Hyperplex64(1, 0))
    assert_almost_equal(HyperplexInt(0, 1) ** HyperplexInt(2, 0), Hyperplex64(1, 0))
    assert_almost_equal(HyperplexInt(2,1) ** 2, Hyperplex64(5,4))
    assert_almost_equal(HyperplexInt(2,1) ** HyperplexInt(2,0), Hyperplex64(5,4))