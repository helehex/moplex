# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_equal
from _testing import assert_almost_equal

from moplex.math.math import *


def main():
    test_sqrt()
    test_rsqrt()


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