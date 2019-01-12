// todo: should we have swift-comparator so that we can do a `.max(with: \String.count)` etc?

// We can't put this on SemigroupInitializable because the overload sets below are also visible
// on that so there would be ambiguity.
// Putting this on the concrete type makes it the preferred overload for Semigroup
extension Semigroup where A: Comparable {
  public static var max: Semigroup<A> {
    return Semigroup<A>(combine: Swift.max)
  }

  public static var min: Semigroup<A> {
    return Semigroup<A>(combine: Swift.min)
  }
}

extension MonoidInitializable where A: Comparable & FixedWidthInteger, M == Monoid<A> {
  public static var max: Monoid<A> {
    return .init(Monoid(empty: .min, semigroup: .max))
  }

  public static var min: Monoid<A> {
    return.init(Monoid(empty: .max, semigroup: .min))
  }
}

extension MonoidInitializable where A: Comparable & FloatingPoint, M == Monoid<A> {
    public static var max: Self {
        return .init(Monoid(empty: -.greatestFiniteMagnitude, semigroup: .max))
    }

    public static var min: Self {
        return .init(Monoid(empty: .greatestFiniteMagnitude, semigroup: .min))
    }
}
