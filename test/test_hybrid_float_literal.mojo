# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal
from _testing import assert_almost_equal

from moplex.math.limit import NAN
from moplex.math.constants import e, pi
from moplex.hybrid.hybrid_float_literal import *


def main():
    test_is_zero()
    test_is_null()
    test_unitize()
    test_str()
    test_getattr()
    # test_setattr()
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
    assert_true(ComplexFloatLiteral(0, 0).is_zero())
    assert_false(ComplexFloatLiteral(1, 0).is_zero())
    assert_false(ComplexFloatLiteral(0, 1).is_zero())
    assert_false(ComplexFloatLiteral(1, 1).is_zero())

    # +--- [0]
    assert_true(DualplexFloatLiteral(0, 0).is_zero())
    assert_false(DualplexFloatLiteral(1, 0).is_zero())
    assert_false(DualplexFloatLiteral(0, 1).is_zero())
    assert_false(DualplexFloatLiteral(1, 1).is_zero())

    # +--- [1]
    assert_true(HyperplexFloatLiteral(0, 0).is_zero())
    assert_false(HyperplexFloatLiteral(1, 0).is_zero())
    assert_false(HyperplexFloatLiteral(0, 1).is_zero())
    assert_false(HyperplexFloatLiteral(1, 1).is_zero())


def test_is_null():
    # +--- [-1]
    assert_true(ComplexFloatLiteral(0, 0).is_null())
    assert_false(ComplexFloatLiteral(1, 0).is_null())
    assert_false(ComplexFloatLiteral(0, 1).is_null())
    assert_false(ComplexFloatLiteral(1, 1).is_null())

    # +--- [0]
    assert_true(DualplexFloatLiteral(0, 0).is_null())
    assert_false(DualplexFloatLiteral(1, 0).is_null())
    assert_true(DualplexFloatLiteral(0, 1).is_null())
    assert_false(DualplexFloatLiteral(1, 1).is_null())

    # +--- [1]
    assert_true(HyperplexFloatLiteral(0, 0).is_null())
    assert_false(HyperplexFloatLiteral(1, 0).is_null())
    assert_false(HyperplexFloatLiteral(0, 1).is_null())
    assert_true(HyperplexFloatLiteral(1, 1).is_null())


def test_unitize():
    from moplex import Complex64
    assert_almost_equal(HybridFloatLiteral[-4](1, 2).unitize(), Complex64(1, 4))


def test_str():
    assert_equal(ComplexFloatLiteral(1, 2).__str__(), "1.0 + 2.0i")
    assert_equal(DualplexFloatLiteral(1, 2).__str__(), "1.0 + 2.0o")
    assert_equal(HyperplexFloatLiteral(1, 2).__str__(), "1.0 + 2.0x")
    assert_equal(HybridFloatLiteral[-2](1, 2).__str__(), "1.0 + 2.0[-2.0]")
    assert_equal(HybridFloatLiteral[3](1, 2).__str__(), "1.0 + 2.0[3.0]")


def test_getattr():
    assert_equal(ComplexFloatLiteral(1, 2).i, 2)
    assert_equal(DualplexFloatLiteral(1, 2).o, 2)
    assert_equal(HyperplexFloatLiteral(1, 2).x, 2)


# def test_setattr():
#     var complex = ComplexFloatLiteral(1, 2)
#     complex.i = 4
#     assert_equal(complex, ComplexFloatLiteral(1, 4))

#     var dualplex = DualplexFloatLiteral(1, 2)
#     dualplex.o = 4
#     assert_equal(dualplex, DualplexFloatLiteral(1, 4))

#     var hyperplex = HyperplexFloatLiteral(1, 2)
#     hyperplex.x = 4
#     assert_equal(hyperplex, HyperplexFloatLiteral(1, 4))


def test_getcoef():
    var h = ComplexFloatLiteral(1, 2)
    assert_equal(h.getcoef(0), 1)
    assert_equal(h.getcoef(1), 2)


def test_setcoef():
    var h = ComplexFloatLiteral(1, 2)
    h.setcoef(0, 9)
    assert_equal(h, ComplexFloatLiteral(9, 2))
    h.setcoef(1, 8)
    assert_equal(h, ComplexFloatLiteral(9, 8))


def test_min():
    # +--- [-1]
    assert_equal(ComplexFloatLiteral(5, 1).min(ComplexFloatLiteral(9, -8)), ComplexFloatLiteral(5, 1))

    # +--- [0]
    assert_equal(DualplexFloatLiteral(3, 85).min(DualplexFloatLiteral(6, -6)), DualplexFloatLiteral(3, 85))

    # +--- [1]
    assert_equal(HyperplexFloatLiteral(5,1).min(HyperplexFloatLiteral(9,-8)), HyperplexFloatLiteral(9,-8))


def test_max():
    # +--- [-1]
    assert_equal(ComplexFloatLiteral(5,1).max(ComplexFloatLiteral(9,-8)), ComplexFloatLiteral(9,-8))

    # +--- [0]
    assert_equal(DualplexFloatLiteral(3,85).max(DualplexFloatLiteral(6,-6)), DualplexFloatLiteral(6,-6))

    # +--- [1]
    assert_equal(HyperplexFloatLiteral(5,1).max(HyperplexFloatLiteral(9,-8)), HyperplexFloatLiteral(5,1))


def test_add():
    assert_equal(ComplexFloatLiteral(1, 2) + ComplexFloatLiteral(2, 4) + 3, ComplexFloatLiteral(6, 6))
    assert_equal(DualplexFloatLiteral(1, 2) + DualplexFloatLiteral(2, 4) + 3, DualplexFloatLiteral(6, 6))
    assert_equal(HyperplexFloatLiteral(1, 2) + HyperplexFloatLiteral(2, 4) + 3, HyperplexFloatLiteral(6, 6))


def test_sub():
    assert_equal(10 - ComplexFloatLiteral(5, 5) - ComplexFloatLiteral(-1, 1), ComplexFloatLiteral(6, -6))
    assert_equal(10 - DualplexFloatLiteral(5, 5) - DualplexFloatLiteral(-1, 1), DualplexFloatLiteral(6, -6))
    assert_equal(10 - HyperplexFloatLiteral(5, 5) - HyperplexFloatLiteral(-1, 1), HyperplexFloatLiteral(6, -6))


def test_mul():
    # +--- [-1]
    assert_equal(ComplexFloatLiteral(0, 0) * ComplexFloatLiteral(1, 2), ComplexFloatLiteral(0, 0))
    assert_equal(ComplexFloatLiteral(1, 0) * ComplexFloatLiteral(1, 2), ComplexFloatLiteral(1, 2))
    assert_equal(ComplexFloatLiteral(0, 2) * ComplexFloatLiteral(0, 2), ComplexFloatLiteral(-4, 0))
    assert_equal(ComplexFloatLiteral(1, 2) * ComplexFloatLiteral(1, 2), ComplexFloatLiteral(-3, 4))
    
    # +--- [0]
    assert_equal(DualplexFloatLiteral(0, 0) * DualplexFloatLiteral(1, 2), DualplexFloatLiteral(0, 0))
    assert_equal(DualplexFloatLiteral(1, 0) * DualplexFloatLiteral(1, 2), DualplexFloatLiteral(1, 2))
    assert_equal(DualplexFloatLiteral(0, 2) * DualplexFloatLiteral(0, 2), DualplexFloatLiteral(0, 0))
    assert_equal(DualplexFloatLiteral(1, 2) * DualplexFloatLiteral(1, 2), DualplexFloatLiteral(1, 4))
    
    # +--- [1]
    assert_equal(HyperplexFloatLiteral(0, 0) * HyperplexFloatLiteral(1, 2), HyperplexFloatLiteral(0, 0))
    assert_equal(HyperplexFloatLiteral(1, 0) * HyperplexFloatLiteral(1, 2), HyperplexFloatLiteral(1, 2))
    assert_equal(HyperplexFloatLiteral(0, 2) * HyperplexFloatLiteral(0, 2), HyperplexFloatLiteral(4, 0))
    assert_equal(HyperplexFloatLiteral(1, 2) * HyperplexFloatLiteral(1, 2), HyperplexFloatLiteral(5, 4))


def test_truediv():
    from moplex import Complex64, Dualplex64, Hyperplex64

    # +--- [-1]
    assert_almost_equal(ComplexFloatLiteral(0, 0) / ComplexFloatLiteral(1, 2), Complex64(0, 0))
    assert_almost_equal(ComplexFloatLiteral(1, 2) / ComplexFloatLiteral(1, 2), Complex64(1, 0))
    assert_almost_equal(ComplexFloatLiteral(-4, 0) / ComplexFloatLiteral(0, 2), Complex64(0, 2))
    assert_almost_equal(ComplexFloatLiteral(-3, 4) / ComplexFloatLiteral(1, 2), Complex64(1, 2))

    # +--- [0]
    assert_almost_equal(DualplexFloatLiteral(0, 0) / DualplexFloatLiteral(1, 2), Dualplex64(0, 0))
    assert_almost_equal(DualplexFloatLiteral(1, 2) / DualplexFloatLiteral(1, 2), Dualplex64(1, 0))
    assert_almost_equal(DualplexFloatLiteral(0, 0) / DualplexFloatLiteral(0, 2), Dualplex64(NAN, NAN), equal_nan=True)
    assert_almost_equal(DualplexFloatLiteral(1, 4) / DualplexFloatLiteral(1, 2), Dualplex64(1, 2))

    # +--- [1]
    assert_almost_equal(HyperplexFloatLiteral(0, 0) / HyperplexFloatLiteral(1, 2), Hyperplex64(0, 0))
    assert_almost_equal(HyperplexFloatLiteral(1, 2) / HyperplexFloatLiteral(1, 2), Hyperplex64(1, 0))
    assert_almost_equal(HyperplexFloatLiteral(4, 0) / HyperplexFloatLiteral(0, 2), Hyperplex64(0, 2))
    assert_almost_equal(HyperplexFloatLiteral(5, 4) / HyperplexFloatLiteral(1, 2), Hyperplex64(1, 2))