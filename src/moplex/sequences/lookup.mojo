#------ Lookup Tables ------#
#
fn generate_lookup[T: AnyRegType, seq: fn(Int)->T, amount: Int]() -> StaticTuple[amount, T]:
    """
    Use when the index to access a sequence cannot be known at compile time.
    """
    alias result = _generate_lookup[T, seq, amount]()
    return result

fn _generate_lookup[T: AnyRegType, seq: fn(Int)->T, amount: Int]() -> StaticTuple[amount, T]:
    var result: StaticTuple[amount, T] = StaticTuple[amount, T]()
    for i in range(amount):
        result[i] = seq(i)
    return result