# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_true, assert_false, assert_equal

from moplex.eisenstein.rewo.eisenstein_int_literal import *
from moplex.eisenstein.wovo.eisenstein_int_literal import *


def main():
    test_equality()
    test_add()
    test_sub()
    test_mul()
    test_str()


def test_equality():
    assert_true(EisIntLiteral_rewo(0, 1, 2).__eq__(EisIntLiteral_rewo(0, 1, 2)))
    assert_true(EisIntLiteral_rewo(2, 1, 0).__eq__(EisIntLiteral_rewo(2, 1, 0)))
    assert_false(EisIntLiteral_rewo(0, 1, 2).__eq__(EisIntLiteral_rewo(2, 1, 0)))

    assert_false(EisIntLiteral_rewo(0, 1, 2).__ne__(EisIntLiteral_rewo(0, 1, 2)))
    assert_false(EisIntLiteral_rewo(2, 1, 0).__ne__(EisIntLiteral_rewo(2, 1, 0)))
    assert_true(EisIntLiteral_rewo(0, 1, 2).__ne__(EisIntLiteral_rewo(2, 1, 0)))

    assert_true(EisIntLiteral_wovo(0, 1, 2).__eq__(EisIntLiteral_wovo(0, 1, 2)))
    assert_true(EisIntLiteral_wovo(2, 1, 0).__eq__(EisIntLiteral_wovo(2, 1, 0)))
    assert_false(EisIntLiteral_wovo(0, 1, 2).__eq__(EisIntLiteral_wovo(2, 1, 0)))

    assert_false(EisIntLiteral_wovo(0, 1, 2).__ne__(EisIntLiteral_wovo(0, 1, 2)))
    assert_false(EisIntLiteral_wovo(2, 1, 0).__ne__(EisIntLiteral_wovo(2, 1, 0)))
    assert_true(EisIntLiteral_wovo(0, 1, 2).__ne__(EisIntLiteral_wovo(2, 1, 0)))


def test_add():
    assert_equal(EisIntLiteral_rewo(0, 1, 2) + EisIntLiteral_rewo(2, 1, 0), EisIntLiteral_rewo(2, 2, 2))
    assert_equal(EisIntLiteral_wovo(0, 1, 2) + EisIntLiteral_wovo(2, 1, 0), EisIntLiteral_wovo(2, 2, 2))


def test_sub():
    assert_equal(EisIntLiteral_rewo(0, 1, 2).__sub__(EisIntLiteral_rewo(2, 1, 0)), EisIntLiteral_rewo(-2, 0, 2))
    assert_equal(EisIntLiteral_wovo(0, 1, 2).__sub__(EisIntLiteral_wovo(2, 1, 0)), EisIntLiteral_wovo(-2, 0, 2))


def test_mul():
    assert_equal(EisIntLiteral_rewo(1, 0, 0).__mul__(EisIntLiteral_rewo(1, 0, 0)), EisIntLiteral_rewo(0, 0, 1))
    assert_equal(EisIntLiteral_wovo(1, 0, 0).__mul__(EisIntLiteral_wovo(1, 0, 0)), EisIntLiteral_wovo(0, 0, 1))

    assert_equal(EisIntLiteral_rewo(0, 1, 0).__mul__(EisIntLiteral_rewo(0, 1, 0)), EisIntLiteral_rewo(0, 1, 0))
    assert_equal(EisIntLiteral_wovo(0, 1, 0).__mul__(EisIntLiteral_wovo(0, 1, 0)), EisIntLiteral_wovo(0, 1, 0))

    assert_equal(EisIntLiteral_rewo(0, 0, 1).__mul__(EisIntLiteral_rewo(0, 0, 1)), EisIntLiteral_rewo(1, 0, 0))
    assert_equal(EisIntLiteral_wovo(0, 0, 1).__mul__(EisIntLiteral_wovo(0, 0, 1)), EisIntLiteral_wovo(1, 0, 0))

    assert_equal(EisIntLiteral_rewo(1, 0, 1).__mul__(EisIntLiteral_rewo(1, 0, 1)), EisIntLiteral_rewo(0, 1, 0))
    assert_equal(EisIntLiteral_wovo(1, 0, 1).__mul__(EisIntLiteral_wovo(1, 0, 1)), EisIntLiteral_wovo(0, 1, 0))


def test_str():
    var a = EisIntLiteral_rewo(0, 1, 2)
    var b = EisIntLiteral_wovo(0, 1, 2)
    assert_equal(a.__str__(), "(0<+1+>2)")
    assert_equal(b.__str__(), "(0<+1+>2)")