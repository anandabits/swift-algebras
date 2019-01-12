// Numeric was a linear hierarchy with no need to build new types from A and no operators with constraints
// so we can collapse it down to a single implementatoion of each operator.

extension CommutativeMonoidInitializable where A: Numeric, CM == CommutativeMonoid<A> {
  public static var sum: Self {
    return .init(CommutativeMonoid(empty: 0, semigroup: Semigroup(combine: +)))
  }

  public static var product: Self {
    return .init(CommutativeMonoid(empty: 1, semigroup: Semigroup(combine: *)))
  }
}

extension Semiring where A: Numeric {
  public static var numeric: Semiring {
    return Semiring(add: .sum, multiply: .product)
  }
}
