public protocol SemigroupProtocol {
    associatedtype A
    func combine(_: inout A, _: A) -> Void
}
public protocol SemigroupInitializable {
    associatedtype A // this lets us simulate generic extensions, see Comparable for an example
    associatedtype S: SemigroupProtocol
    init(_: S)
}

// TODO: should the generic be S?
public struct Semigroup<A>: SemigroupProtocol {
  // Law: `combine(combine(a, b), c) == combine(a, combine(b, c))` for all a, b, c: A.
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init(combine: @escaping (A, A) -> A) {
    self.mcombine = { accum, a in
      let result = combine(accum, a)
      accum = result
    }
  }

  public init(mcombine: @escaping (inout A, A) -> Void) {
    self.mcombine = mcombine
  }

  public init<S: SemigroupProtocol>(_ semigroup: S) where S.A == A {
    if let semigroup = semigroup as? Semigroup<A> {
        self = semigroup
    } else {
        self.mcombine = semigroup.combine
    }
  }
}
extension Semigroup: SemigroupInitializable { public typealias S = Semigroup<A> }
extension Semigroup: CommutativeSemigroupInitializable { public typealias CS = CommutativeSemigroup<A> }
extension Semigroup: IdempotentSemigroupInitializable { public typealias IS = IdempotentSemigroup<A> }
extension Semigroup: MonoidInitializable { public typealias M = Monoid<A> }
extension Semigroup: CommutativeMonoidInitializable { public typealias CM = CommutativeMonoid<A> }
extension Semigroup: IdempotentMonoidInitializable { public typealias IM = IdempotentMonoid<A> }
extension Semigroup: CommutativeIdempotentSemigroupInitializable { public typealias CIS = CommutativeIdempotentSemigroup<A> }
extension Semigroup: CommutativeIdempotentMonoidInitializable { public typealias CIM = CommutativeIdempotentMonoid<A> }

extension SemigroupProtocol {
  // defined here so it is available on all refining abstractions
  // if we define it instead on all direct refinements of SemigroupProtocol
  // we can run into ambiguity issues when those are merged in a
  // a protocol such as CommutativeMonoidProtocol where two definitions of
  // semigroup are available
  public var semigroup: Semigroup<A> {
    return Semigroup(mcombine: self.combine)
  }

  func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> Semigroup<B> {
    return Semigroup<B>(combine: { lhs, rhs in
      f(self.combine(g(lhs), g(rhs)))
    })
  }

  public var dual: Semigroup<A> {
    return Semigroup { self.combine($1, $0) }
  }

  public func combine(_ lhs: A, _ rhs: A) -> A {
    var result = lhs
    combine(&result, rhs)
    return result
  }
}
