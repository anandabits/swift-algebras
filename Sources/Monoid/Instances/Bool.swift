extension CommutativeIdempotentMonoidInitializable where CIM == CommutativeIdempotentMonoid<Bool> {
  public static var any: Self { return .init(CommutativeIdempotentMonoid(empty: false, semigroup: Semigroup { $0 || $1 })) }
  public static var all: Self { return .init(CommutativeIdempotentMonoid.any.imap((!), (!))) }
}

extension Semigroup where A == Bool {
  public static let bool = Semiring(add: .any, multiply: .all)
}
