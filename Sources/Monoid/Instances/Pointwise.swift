// We would need associated constraints and generic extensions to apply the Initializable pattern here

extension Semigroup {
  public static func pointwise<A0>(into witness: Semigroup<A>) -> Semigroup<(A0) -> A> {
    return .init { lhs, rhs in
      return { witness.combine(lhs($0), rhs($0)) }
    }
  }
  public static func pointwise<A0, S: SemigroupProtocol>(into witness: S) -> Semigroup<(A0) -> A> where S.A == A {
    return .init { lhs, rhs in
      return { witness.combine(lhs($0), rhs($0)) }
    }
  }
}

extension Monoid {
  public static func pointwise<A0>(into witness: Monoid<A>) -> Monoid<(A0) -> A> {
    return .init(
      empty: { _ in witness.empty },
      semigroup: Semigroup.pointwise(into: witness.semigroup)
    )
  }
  public static func pointwise<A0, M: MonoidProtocol>(into witness: M) -> Monoid<(A0) -> A> where M.A == A {
    return .init(
      empty: { _ in witness.empty },
      semigroup: Semigroup.pointwise(into: witness.semigroup)
    )
  }
}

extension CommutativeMonoid {
  public static func pointwise<A0>(into witness: CommutativeMonoid<A>) -> CommutativeMonoid<(A0) -> A> {
    return .init(
      empty: { _ in witness.empty },
      semigroup: Semigroup.pointwise(into: witness.semigroup)
    )
  }
  public static func pointwise<A0, M: CommutativeMonoidProtocol>(into witness: M) -> CommutativeMonoid<(A0) -> A> where M.A == A {
    return .init(
      empty: { _ in witness.empty },
      semigroup: Semigroup.pointwise(into: witness.semigroup)
    )
  }
}

extension IdempotentMonoid {
  public static func pointwise<A0>(into witness: IdempotentMonoid<A>) -> IdempotentMonoid<(A0) -> A> {
    return .init(
      empty: { _ in witness.empty },
      semigroup: Semigroup.pointwise(into: witness.semigroup)
    )
  }
  public static func pointwise<A0, M: IdempotentMonoidProtocol>(into witness: M) -> IdempotentMonoid<(A0) -> A> where M.A == A {
    return .init(
      empty: { _ in witness.empty },
      semigroup: Semigroup.pointwise(into: witness.semigroup)
    )
  }
}
