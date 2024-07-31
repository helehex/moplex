# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal
from _testing import assert_almost_equal

from moplex.math.limit import NAN
from moplex.math.constants import e, pi
from moplex.hybrid.hybrid_int_literal import *


def main():
    test_is_zero()
    test_is_null()
    test_unitize()
    test_str()
    test_getcoef()
    test_setcoef()
    # test_denomer()
    # test_measure()
    test_min()
    test_max()
    test_add()
    test_sub()
    test_mul()
    test_truediv()
    # test_floordiv()
    # test_pow()


def test_is_zero():
    # +--- [-1]
    assert_true(ComplexIntLiteral(0, 0).is_zero())
    assert_false(ComplexIntLiteral(1, 0).is_zero())
    assert_false(ComplexIntLiteral(0, 1).is_zero())
    assert_false(ComplexIntLiteral(1, 1).is_zero())

    # +--- [0]
    assert_true(DualplexIntLiteral(0, 0).is_zero())
    assert_false(DualplexIntLiteral(1, 0).is_zero())
    assert_false(DualplexIntLiteral(0, 1).is_zero())
    assert_false(DualplexIntLiteral(1, 1).is_zero())

    # +--- [1]
    assert_true(HyperplexIntLiteral(0, 0).is_zero())
    assert_false(HyperplexIntLiteral(1, 0).is_zero())
    assert_false(HyperplexIntLiteral(0, 1).is_zero())
    assert_false(HyperplexIntLiteral(1, 1).is_zero())


def test_is_null():
    # +--- [-1]
    assert_true(ComplexIntLiteral(0, 0).is_null())
    assert_false(ComplexIntLiteral(1, 0).is_null())
    assert_false(ComplexIntLiteral(0, 1).is_null())
    assert_false(ComplexIntLiteral(1, 1).is_null())

    # +--- [0]
    assert_true(DualplexIntLiteral(0, 0).is_null())
    assert_false(DualplexIntLiteral(1, 0).is_null())
    assert_true(DualplexIntLiteral(0, 1).is_null())
    assert_false(DualplexIntLiteral(1, 1).is_null())

    # +--- [1]
    assert_true(HyperplexIntLiteral(0, 0).is_null())
    assert_false(HyperplexIntLiteral(1, 0).is_null())
    assert_false(HyperplexIntLiteral(0, 1).is_null())
    assert_true(HyperplexIntLiteral(1, 1).is_null())


def test_unitize():
    from moplex import Complex64
    assert_almost_equal(HybridIntLiteral[-4](1, 2).unitize(), Complex64(1, 4))


def test_str():
    assert_equal(ComplexIntLiteral(1, 2).__str__(), "1 + 2i")
    assert_equal(DualplexIntLiteral(1, 2).__str__(), "1 + 2o")
    assert_equal(HyperplexIntLiteral(1, 2).__str__(), "1 + 2x")
    assert_equal(HybridIntLiteral[-2](1, 2).__str__(), "1 + 2[-2]")
    assert_equal(HybridIntLiteral[3](1, 2).__str__(), "1 + 2[3]")


def test_getcoef():
    var h = ComplexIntLiteral(1, 2)
    assert_equal(h.getcoef(0), 1)
    assert_equal(h.getcoef(1), 2)


def test_setcoef():
    var h = ComplexIntLiteral(1, 2)
    h.setcoef(0, 9)
    assert_equal(h, ComplexIntLiteral(9, 2))
    h.setcoef(1, 8)
    assert_equal(h, ComplexIntLiteral(9, 8))


def test_min():
    # +--- [-1]
    assert_equal(ComplexIntLiteral(5, 1).min(ComplexIntLiteral(9, -8)), ComplexIntLiteral(5, 1))

    # +--- [0]
    assert_equal(DualplexIntLiteral(3, 85).min(DualplexIntLiteral(6, -6)), DualplexIntLiteral(3, 85))

    # +--- [1]
    assert_equal(HyperplexIntLiteral(5,1).min(HyperplexIntLiteral(9,-8)), HyperplexIntLiteral(9,-8))


def test_max():
    # +--- [-1]
    assert_equal(ComplexIntLiteral(5,1).max(ComplexIntLiteral(9,-8)), ComplexIntLiteral(9,-8))

    # +--- [0]
    assert_equal(DualplexIntLiteral(3,85).max(DualplexIntLiteral(6,-6)), DualplexIntLiteral(6,-6))

    # +--- [1]
    assert_equal(HyperplexIntLiteral(5,1).max(HyperplexIntLiteral(9,-8)), HyperplexIntLiteral(5,1))


def test_add():
    assert_equal(ComplexIntLiteral(1, 2) + ComplexIntLiteral(2, 4) + 3, ComplexIntLiteral(6, 6))
    assert_equal(DualplexIntLiteral(1, 2) + DualplexIntLiteral(2, 4) + 3, DualplexIntLiteral(6, 6))
    assert_equal(HyperplexIntLiteral(1, 2) + HyperplexIntLiteral(2, 4) + 3, HyperplexIntLiteral(6, 6))


def test_sub():
    assert_equal(10 - ComplexIntLiteral(5, 5) - ComplexIntLiteral(-1, 1), ComplexIntLiteral(6, -6))
    assert_equal(10 - DualplexIntLiteral(5, 5) - DualplexIntLiteral(-1, 1), DualplexIntLiteral(6, -6))
    assert_equal(10 - HyperplexIntLiteral(5, 5) - HyperplexIntLiteral(-1, 1), HyperplexIntLiteral(6, -6))


def test_mul():
    # +--- [-1]
    assert_equal(ComplexIntLiteral(0, 0) * ComplexIntLiteral(1, 2), ComplexIntLiteral(0, 0))
    assert_equal(ComplexIntLiteral(1, 0) * ComplexIntLiteral(1, 2), ComplexIntLiteral(1, 2))
    assert_equal(ComplexIntLiteral(0, 2) * ComplexIntLiteral(0, 2), ComplexIntLiteral(-4, 0))
    assert_equal(ComplexIntLiteral(1, 2) * ComplexIntLiteral(1, 2), ComplexIntLiteral(-3, 4))
    
    # +--- [0]
    assert_equal(DualplexIntLiteral(0, 0) * DualplexIntLiteral(1, 2), DualplexIntLiteral(0, 0))
    assert_equal(DualplexIntLiteral(1, 0) * DualplexIntLiteral(1, 2), DualplexIntLiteral(1, 2))
    assert_equal(DualplexIntLiteral(0, 2) * DualplexIntLiteral(0, 2), DualplexIntLiteral(0, 0))
    assert_equal(DualplexIntLiteral(1, 2) * DualplexIntLiteral(1, 2), DualplexIntLiteral(1, 4))
    
    # +--- [1]
    assert_equal(HyperplexIntLiteral(0, 0) * HyperplexIntLiteral(1, 2), HyperplexIntLiteral(0, 0))
    assert_equal(HyperplexIntLiteral(1, 0) * HyperplexIntLiteral(1, 2), HyperplexIntLiteral(1, 2))
    assert_equal(HyperplexIntLiteral(0, 2) * HyperplexIntLiteral(0, 2), HyperplexIntLiteral(4, 0))
    assert_equal(HyperplexIntLiteral(1, 2) * HyperplexIntLiteral(1, 2), HyperplexIntLiteral(5, 4))


def test_truediv():
    from moplex import Complex64, Dualplex64, Hyperplex64

    # +--- [-1]
    assert_almost_equal(ComplexIntLiteral(0, 0) / ComplexIntLiteral(1, 2), Complex64(0, 0))
    assert_almost_equal(ComplexIntLiteral(1, 2) / ComplexIntLiteral(1, 2), Complex64(1, 0))
    assert_almost_equal(ComplexIntLiteral(-4, 0) / ComplexIntLiteral(0, 2), Complex64(0, 2))
    assert_almost_equal(ComplexIntLiteral(-3, 4) / ComplexIntLiteral(1, 2), Complex64(1, 2))

    # +--- [0]
    assert_almost_equal(DualplexIntLiteral(0, 0) / DualplexIntLiteral(1, 2), Dualplex64(0, 0))
    assert_almost_equal(DualplexIntLiteral(1, 2) / DualplexIntLiteral(1, 2), Dualplex64(1, 0))
    assert_almost_equal(DualplexIntLiteral(0, 0) / DualplexIntLiteral(0, 2), Dualplex64(NAN, NAN), equal_nan=True)
    assert_almost_equal(DualplexIntLiteral(1, 4) / DualplexIntLiteral(1, 2), Dualplex64(1, 2))

    # +--- [1]
    assert_almost_equal(HyperplexIntLiteral(0, 0) / HyperplexIntLiteral(1, 2), Hyperplex64(0, 0))
    assert_almost_equal(HyperplexIntLiteral(1, 2) / HyperplexIntLiteral(1, 2), Hyperplex64(1, 0))
    assert_almost_equal(HyperplexIntLiteral(4, 0) / HyperplexIntLiteral(0, 2), Hyperplex64(0, 2))
    assert_almost_equal(HyperplexIntLiteral(5, 4) / HyperplexIntLiteral(1, 2), Hyperplex64(1, 2))