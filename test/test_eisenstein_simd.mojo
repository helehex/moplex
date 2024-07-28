# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal

from moplex.eisenstein.rewo.eisenstein_simd import *
from moplex.eisenstein.wovo.eisenstein_simd import *


def main():
    test_equality()
    test_add()
    test_sub()
    test_mul()
    test_str()


def test_equality():
    assert_true(EisSIMD_rewo[size = 2](0, 1, 2).__eq__[None](EisSIMD_rewo[size = 2](0, 1, 2)))
    assert_true(EisSIMD_rewo[size = 2](2, 1, 0).__eq__[None](EisSIMD_rewo[size = 2](2, 1, 0)))
    assert_false(EisSIMD_rewo[size = 2](0, 1, 2).__eq__[None](EisSIMD_rewo[size = 2](2, 1, 0)))

    assert_false(EisSIMD_rewo[size = 2](0, 1, 2).__ne__[None](EisSIMD_rewo[size = 2](0, 1, 2)))
    assert_false(EisSIMD_rewo[size = 2](2, 1, 0).__ne__[None](EisSIMD_rewo[size = 2](2, 1, 0)))
    assert_true(EisSIMD_rewo[size = 2](0, 1, 2).__ne__[None](EisSIMD_rewo[size = 2](2, 1, 0)))

    assert_true(EisSIMD_wovo[size = 2](0, 1, 2).__eq__[None](EisSIMD_wovo[size = 2](0, 1, 2)))
    assert_true(EisSIMD_wovo[size = 2](2, 1, 0).__eq__[None](EisSIMD_wovo[size = 2](2, 1, 0)))
    assert_false(EisSIMD_wovo[size = 2](0, 1, 2).__eq__[None](EisSIMD_wovo[size = 2](2, 1, 0)))

    assert_false(EisSIMD_wovo[size = 2](0, 1, 2).__ne__[None](EisSIMD_wovo[size = 2](0, 1, 2)))
    assert_false(EisSIMD_wovo[size = 2](2, 1, 0).__ne__[None](EisSIMD_wovo[size = 2](2, 1, 0)))
    assert_true(EisSIMD_wovo[size = 2](0, 1, 2).__ne__[None](EisSIMD_wovo[size = 2](2, 1, 0)))


def test_add():
    assert_equal(EisSIMD_rewo[size = 2](0, 1, 2).__add__(EisSIMD_rewo[size = 2](2, 1, 0)), EisSIMD_rewo[size = 2](2, 2, 2))
    assert_equal(EisSIMD_wovo[size = 2](0, 1, 2).__add__(EisSIMD_wovo[size = 2](2, 1, 0)), EisSIMD_wovo[size = 2](2, 2, 2))


def test_sub():
    assert_equal(EisSIMD_rewo[size = 2](0, 1, 2).__sub__(EisSIMD_rewo[size = 2](2, 1, 0)), EisSIMD_rewo[size = 2](-2, 0, 2))
    assert_equal(EisSIMD_wovo[size = 2](0, 1, 2).__sub__(EisSIMD_wovo[size = 2](2, 1, 0)), EisSIMD_wovo[size = 2](-2, 0, 2))


def test_mul():
    assert_equal(EisSIMD_rewo[size = 2](1, 0, 0).__mul__(EisSIMD_rewo[size = 2](1, 0, 0)), EisSIMD_rewo[size = 2](0, 0, 1))
    assert_equal(EisSIMD_wovo[size = 2](1, 0, 0).__mul__(EisSIMD_wovo[size = 2](1, 0, 0)), EisSIMD_wovo[size = 2](0, 0, 1))

    assert_equal(EisSIMD_rewo[size = 2](0, 1, 0).__mul__(EisSIMD_rewo[size = 2](0, 1, 0)), EisSIMD_rewo[size = 2](0, 1, 0))
    assert_equal(EisSIMD_wovo[size = 2](0, 1, 0).__mul__(EisSIMD_wovo[size = 2](0, 1, 0)), EisSIMD_wovo[size = 2](0, 1, 0))

    assert_equal(EisSIMD_rewo[size = 2](0, 0, 1).__mul__(EisSIMD_rewo[size = 2](0, 0, 1)), EisSIMD_rewo[size = 2](1, 0, 0))
    assert_equal(EisSIMD_wovo[size = 2](0, 0, 1).__mul__(EisSIMD_wovo[size = 2](0, 0, 1)), EisSIMD_wovo[size = 2](1, 0, 0))

    assert_equal(EisSIMD_rewo[size = 2](1, 0, 1).__mul__(EisSIMD_rewo[size = 2](1, 0, 1)), EisSIMD_rewo[size = 2](0, 1, 0))
    assert_equal(EisSIMD_wovo[size = 2](1, 0, 1).__mul__(EisSIMD_wovo[size = 2](1, 0, 1)), EisSIMD_wovo[size = 2](0, 1, 0))


def test_str():
    assert_equal(EisSIMD_rewo[size = 2](0, 1, 2).__str__(), "(0<+1+>2)\n(0<+1+>2)")
    assert_equal(EisSIMD_wovo[size = 2](0, 1, 2).__str__(), "(0<+1+>2)\n(0<+1+>2)")