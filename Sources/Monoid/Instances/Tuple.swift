// The unconstrained tuple function does not provide type context for dot shorthand but it can be regained
// using a first argument label that is unique and resolves ambiguity you were already running into in testTuple
public func tuple<A, B>(semigroups a: Semigroup<A>, _ b: Semigroup<B>) -> Tuple2<Semigroup<A>, Semigroup<B>> {
  return .init(a: a, b: b)
}
public func tuple<A, B>(monoids a: Monoid<A>, _ b: Monoid<B>) -> Tuple2<Monoid<A>, Monoid<B>> {
  return .init(a: a, b: b)
}
public func tuple2<A, B>(_ a: A, _ b: B) -> Tuple2<A, B> {
  return .init(a: a, b: b)
}
public struct Tuple2<T, U> { // can't use A, B because the associated type for Semigroup, etc is called A
  public let a: T
  public let b: U
}
extension Tuple2: SemigroupProtocol where T: SemigroupProtocol, U: SemigroupProtocol {
  public typealias A = (T.A, U.A)
  public func combine(_ lhs: inout A, _ rhs: A) {
    a.combine(&lhs.0, rhs.0)
    b.combine(&lhs.1, rhs.1)
  }
}
extension Tuple2: MonoidProtocol where T: MonoidProtocol, U: MonoidProtocol {
  public var empty: (T.A, U.A) {
    return (a.empty, b.empty)
  }
}
// other conditional conformances as appropriate, some of which will not require implementation

public func tuple<A, B, C>(semigroups a: Semigroup<A>, _ b: Semigroup<B>, _ c: Semigroup<C>) -> Tuple3<Semigroup<A>, Semigroup<B>, Semigroup<C>> {
  return .init(a: a, b: b, c: c)
}
public func tuple<A, B, C>(monoids a: Monoid<A>, _ b: Monoid<B>, _ c: Monoid<C>) -> Tuple3<Monoid<A>, Monoid<B>, Monoid<C>> {
  return .init(a: a, b: b, c: c)
}
public func tuple<A, B, C>(_ a: A, _ b: B, _ c: C) -> Tuple3<A, B, C> {
  return .init(a: a, b: b, c: c)
}
public struct Tuple3<T, U, V> { // can't use A, B because the associated type for Semigroup, etc is called A
  public let a: T
  public let b: U
  public let c: V
}
extension Tuple3: SemigroupProtocol where T: SemigroupProtocol, U: SemigroupProtocol, V: SemigroupProtocol {
  public typealias A = (T.A, U.A, V.A)
  public func combine(_ lhs: inout A, _ rhs: A) {
    a.combine(&lhs.0, rhs.0)
    b.combine(&lhs.1, rhs.1)
    c.combine(&lhs.2, rhs.2)
  }
}
extension Tuple3: MonoidProtocol where T: MonoidProtocol, U: MonoidProtocol, V: MonoidProtocol {
  public var empty: (T.A, U.A, V.A) {
    return (a.empty, b.empty, c.empty)
  }
}
// other conditional conformances as appropriate, some of which will not require implementation
