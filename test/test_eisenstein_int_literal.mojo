# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

from testing import assert_equal

from moplex.eisenstein import *


def main():
    test_add()


def test_add():
    assert_equal(LitIntE_rewo(1, 2) + LitIntE_rewo(2, 1), LitIntE_rewo(3, 3))
    assert_equal(LitIntE_wovo(1, 2) + LitIntE_wovo(2, 1), LitIntE_wovo(3, 3))