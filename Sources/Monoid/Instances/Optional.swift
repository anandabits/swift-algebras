extension SemigroupInitializable where S == Semigroup<A> {
  public static var last: Self {
    return .init(Semigroup { _, last in last })
  }

  public static var first: Semigroup<A> {
    return .init(Semigroup { first, _ in first })
  }
}

// can't put this on SemigroupInitializable because A must be the argument to Semigroup in that context
// we would need true generic extensions to be able to do that
extension Semigroup {
  public static var lastNonNil: Semigroup<A?> {
    return .init { $1 ?? $0 }
  }

  public static var firstNonNil: Semigroup<A?> {
    return .init { $0 ?? $1 }
  }
}

extension Semigroup {
  public static func optional(_ witness: Semigroup<A>) -> Monoid<A?> {
    return Monoid<A?>(empty: nil, semigroup: Semigroup<A?>.init { lhs, rhs -> Void in
      // TODO: better way?
      guard lhs != nil, let rhs1 = rhs else { lhs = lhs ?? rhs; return }
      witness.mcombine(&lhs!, rhs1)
    })
  }

  public static func optional<S: SemigroupProtocol>(_ witness: S) -> Monoid<A?> where S.A == A {
    return Monoid<A?>(empty: nil, semigroup: Semigroup<A?>.init { lhs, rhs -> Void in
      // TODO: better way?
      guard lhs != nil, let rhs1 = rhs else { lhs = lhs ?? rhs; return }
      witness.combine(&lhs!, rhs1)
    })
  }
}

extension Monoid {
  public static var last: Monoid<A?> {
    return .init(empty: nil, semigroup: Semigroup.lastNonNil)
  }

  public static var first: Monoid<A?> {
    return self.last.dual
  }
}
