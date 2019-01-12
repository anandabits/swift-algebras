extension CommutativeMonoidInitializable where CM == CommutativeMonoid<Bool> {
  public static var any: Self { return .init(CommutativeMonoid(empty: false, semigroup: Semigroup { $0 || $1 })) }
  public static var all: Self { return .init(CommutativeMonoid.any.imap((!), (!))) }
}

// We can't put this on IdempotentMonoidInitializable or it would produce ambiguity with the
// CommutativeMonoidInitializable overload because both would be visible on SemigroupInitializable and MonoiInitializable
extension IdempotentMonoid where A == Bool {
  public static let any = IdempotentMonoid(empty: false, semigroup: .any)
  public static let all = any.imap((!), (!))
}

extension Semigroup where A == Bool {
  public static let bool = Semiring(add: .any, multiply: .all)
}
