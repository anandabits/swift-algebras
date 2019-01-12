public protocol MonoidProtocol: SemigroupProtocol {
    associatedtype A
    var empty: A { get }
}
public protocol MonoidInitializable {
    associatedtype A // this lets us simulate generic extensions, see Comparable for an example
    associatedtype M: MonoidProtocol
    init(_: M)
}

// TODO: should the generic be M?
public struct Monoid<A>: MonoidProtocol {
  public let empty: A
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init<S: SemigroupProtocol>(empty: A, semigroup: S) where S.A == A {
    self.empty = empty
    self.mcombine = semigroup.combine
  }

  public init(empty: A, combine: @escaping (A, A) -> A) {
    self.empty = empty
    self.mcombine = { lhs, rhs in lhs = combine(lhs, rhs) }
  }

  public init(empty: A, mcombine: @escaping (inout A, A) -> Void) {
    self.empty = empty
    self.mcombine = mcombine
  }

  public init<M: MonoidProtocol>(_ monoid: M) where M.A == A {
    if let monoid = monoid as? Monoid<A> {
        self = monoid
    } else {
        self.empty = monoid.empty
        self.mcombine = monoid.combine
    }
  }

  public init(empty: A, semigroup: Semigroup<A>) {
    self.empty = empty
    self.mcombine = semigroup.mcombine
  }
}
extension Monoid: MonoidInitializable { public typealias M = Monoid<A> }
extension Monoid: CommutativeMonoidInitializable { public typealias CM = CommutativeMonoid<A> }
extension Monoid: IdempotentMonoidInitializable { public typealias IM = IdempotentMonoid<A> }
extension Monoid: CommutativeIdempotentMonoidInitializable { public typealias CIM = CommutativeIdempotentMonoid<A> }

extension MonoidProtocol {
  public var monoid: Monoid<A> {
    return Monoid(empty: self.empty, semigroup: self.semigroup)
  }

  // This is overloading SemigroupProtocol.imap on the return type so users need
  // to provide a type context if one is not already present.
  // Instead, we could define Imap<A> that conditionally conforms
  // to the protocols and we would only need a single method on SemigroupProtocol
  // instead of redefining imap at every relevant level of the abstraction hierarchy
  // The same goes for other operators such as dual
  public func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> Monoid<B> {
    return Monoid<B>(empty: f(self.empty), semigroup: self.semigroup.imap(f, g))
  }

  public var dual: Monoid<A> {
    return Monoid(empty: empty, semigroup: semigroup.dual)
  }
}
