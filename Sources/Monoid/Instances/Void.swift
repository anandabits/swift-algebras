extension CommutativeIdempotentMonoidInitializable where CIM == CommutativeIdempotentMonoid<()> {
  public static var void: Self { return .init(CommutativeIdempotentMonoid(empty: (), mcombine: { _, _ in })) }
}

extension Semiring where A == () {
  public static let void = Semiring(add: .void, multiply: .void)
}
