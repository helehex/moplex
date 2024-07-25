# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_equal

from moplex.eisenstein import *


def main():
    test_add()


def test_add():
    assert_equal(ESIMD_rewo[DType.index, 2](1, 2) + ESIMD_rewo[DType.index, 2](2, 1), ESIMD_rewo[DType.index, 2](3, 3))
    assert_equal(ESIMD_wovo[DType.index, 2](1, 2) + ESIMD_wovo[DType.index, 2](2, 1), ESIMD_wovo[DType.index, 2](3, 3))