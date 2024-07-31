# x----------------------------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x----------------------------------------------------------------------------------------------x #

from testing import assert_equal
from _testing import assert_almost_equal

from moplex.math.math import *


def main():
    test_sqrt()
    test_rsqrt()
    test_exp()
    test_lambertw()


def test_sqrt():
    # +--- FloatLiteral
    assert_almost_equal(sqrt(1.0), 1.0)
    assert_almost_equal(sqrt(2.0), 1.4142135623)
    assert_almost_equal(sqrt(4.0), 2.0)


def test_rsqrt():
    # +--- FloatLiteral
    assert_almost_equal(rsqrt(1.0), 1.0)
    assert_almost_equal(rsqrt(2.0), 0.707106781187)
    assert_almost_equal(rsqrt(4.0), 0.5)


def test_exp():
    from moplex import Complex64, Dualplex64, Hyperplex64, e
    assert_almost_equal(exp(Float64(0)), 1)
    assert_almost_equal(exp(Float64(1)), e)
    assert_almost_equal(exp(Complex64(0)), 1)
    assert_almost_equal(exp(Complex64(1)), e)
    assert_almost_equal(exp(Dualplex64(0)), 1)
    assert_almost_equal(exp(Dualplex64(1)), e)
    assert_almost_equal(exp(Hyperplex64(0)), 1)
    assert_almost_equal(exp(Hyperplex64(1)), e)


def test_lambertw():
    from moplex import Complex64, omg
    assert_almost_equal(lw(Complex64(1, 0)), omg)