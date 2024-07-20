# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal
from _testing import assert_almost_equal

from moplex.math.limit import NAN, INF
from moplex.math.constants import e, pi
from moplex.hybrid.multiplex_simd import *


def main():
    test_is_zero()
    test_is_null()
    test_str()
    # test_add()
    # test_mul()
    # test_truediv()


def test_is_zero():
    assert_true(Multiplex64(0, 0, 0, 0).is_zero())
    assert_false(Multiplex64(1, 0, 0, 0).is_zero())
    assert_false(Multiplex64(0, 1, 0, 0).is_zero())
    assert_false(Multiplex64(0, 0, 1, 0).is_zero())
    assert_false(Multiplex64(0, 0, 0, 1).is_zero())


def test_is_null():
    assert_true(Multiplex64(0, 0, 0, 0).is_null())
    assert_false(Multiplex64(1, 0, 0, 0).is_null())
    assert_false(Multiplex64(0, 1, 0, 0).is_null())
    assert_true(Multiplex64(0, 0, 1, 0).is_null())
    assert_false(Multiplex64(0, 0, 0, 1).is_null())


def test_str():
    assert_equal(Multiplex64(1, 2, 3, 4).__str__(), "1.0 + 2.0i + 3.0o + 4.0x")


# def test_add():
#     from moplex import Complex64, Dualplex64, Hyperplex64
#     assert_equal(Complex64(1, 1) + Dualplex64(1, 1) + Hyperplex64(1, 1), Multiplex64(3, 1, 1, 1))


# def test_mul():
#     assert_equal(Multiplex64(0, 1, 0, 0) * Multiplex64(0, 1, 0, 0), -1)
#     assert_equal(Multiplex64(0, 0, 1, 0) * Multiplex64(0, 0, 1, 0), 0)
#     assert_equal(Multiplex64(0, 0, 0, 1) * Multiplex64(0, 0, 0, 1), 1)
#     assert_equal(Multiplex64(0, 0, 1, 1) * Multiplex64(0, 0, 1, 1), 1)


# def test_truediv():
#     var multiplex = Multiplex64(10,2,3,4) / Multiplex64(-4,3,2,1)
#     print(multiplex)
#     print("10 + 2i + 3o + 4x =  ", (multiplex*Multiplex64(-4,3,2,1)))