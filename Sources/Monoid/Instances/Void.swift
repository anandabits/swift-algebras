// We can't use the Initializable pattern for both Commutative and Idempotent
// unless we bring them back together in the abstraction graph
// by introducing CommutativeIdempotentMonoid which would
// give us a single leaf in the hierarchy on which to place the void operator.
// Without that we need to carefully choose an overload set that does not produce ambiguity.

extension IdempotentSemigroup where A == () {
  public static let void = IdempotentSemigroup(mcombine: { _, _ in })
}

extension CommutativeMonoidInitializable where CM == CommutativeMonoid<()> {
  public static var void: Self { return .init(CommutativeMonoid(empty: (), mcombine: { _, _ in })) }
}

extension IdempotentMonoid where A == () {
  public static let void = IdempotentMonoid(empty: (), mcombine: { _, _ in })
}

extension Semiring where A == () {
  public static let void = Semiring(add: .void, multiply: .void)
}
