extension Semigroup {
  // TODO: rename arg to something like `uniquingKeysWith`?
  //       Then it could be `.merge(uniquingKeysWith: .first)`
  public static func merge<K>(with witness: Semigroup<A>) -> Semigroup<[K: A]> {
    return .init { lhs, rhs in
      lhs.merge(rhs, uniquingKeysWith: witness.combine)
    }
  }

  public static func merge<K, S: SemigroupProtocol>(with witness: S) -> Semigroup<[K: A]> where S.A == A {
    return .init { lhs, rhs in
      lhs.merge(rhs, uniquingKeysWith: witness.combine)
    }
  }
}

extension Monoid {
  // TODO: rename arg to something like `uniquingKeysWith`?
  public static func merge<K>(with witness: Monoid<A>) -> Monoid<[K: A]> {
    return .init(
      empty: [:],
      semigroup: Semigroup.merge(with: witness.semigroup)
    )
  }

  public static func merge<K, M: MonoidProtocol>(with witness: M) -> Monoid<[K: A]> where M.A == A {
    return .init(
      empty: [:],
      semigroup: Semigroup.merge(with: witness.semigroup)
    )
  }
}
