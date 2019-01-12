extension MonoidInitializable where M == Monoid<A>, A: RangeReplaceableCollection {
  public static var joined: Self {
    return .init(Monoid<A>(empty: .init(), semigroup: Semigroup { $0.append(contentsOf: $1) }))
  }

  public static func joined(separator: A.Element) -> Self {
    return .init(Monoid<A>(empty: .init(), semigroup: Semigroup(mcombine: {
      if !$0.isEmpty { $0.append(separator) }
      $0.append(contentsOf: $1)
    })))
  }
}
