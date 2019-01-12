// TODO: CommutativeSemigroup

public protocol CommutativeSemigroupProtocol: SemigroupProtocol {
    associatedtype A
}
public protocol CommutativeSemigroupInitializable {
    associatedtype A
    associatedtype CS: CommutativeSemigroupProtocol
    init(_: CS)
}
public struct CommutativeSemigroup<A>: CommutativeSemigroupProtocol {
  public let combine: (A, A) -> A
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init(combine: @escaping (A, A) -> A) {
    self.combine = combine
    self.mcombine = { accum, a in
      let result = combine(accum, a)
      accum = result
    }
  }

  public init(mcombine: @escaping (inout A, A) -> Void) {
    self.mcombine = mcombine
    self.combine = { accum, a in
      var copy = accum
      mcombine(&copy, a)
      return copy
    }
  }

  public init<S: CommutativeSemigroupProtocol>(_ s: S) where S.A == A {
    if let s = s as? CommutativeSemigroup<A> {
        self = s
    } else {
        self.combine = s.combine
        self.mcombine = s.combine
    }
  }
}
extension CommutativeSemigroup: CommutativeSemigroupInitializable { public typealias CS = CommutativeSemigroup<A> }
extension CommutativeSemigroup: CommutativeMonoidInitializable { public typealias CM = CommutativeMonoid<A> }
extension CommutativeSemigroup: CommutativeIdempotentSemigroupInitializable { public typealias CIS = CommutativeIdempotentSemigroup<A> }
extension CommutativeSemigroup: CommutativeIdempotentMonoidInitializable { public typealias CIM = CommutativeIdempotentMonoid<A> }

extension CommutativeSemigroupProtocol {
  func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> CommutativeSemigroup<B> {
    return .init(combine: { lhs, rhs in
      f(self.combine(g(lhs), g(rhs)))
    })
  }

  public var dual: CommutativeSemigroup<A> {
    return .init { self.combine($1, $0) }
  }
}

public protocol IdempotentSemigroupProtocol: SemigroupProtocol {
    associatedtype A
}
public protocol IdempotentSemigroupInitializable {
    associatedtype A
    associatedtype IS: IdempotentSemigroupProtocol
    init(_: IS)
}
public struct IdempotentSemigroup<A>: IdempotentSemigroupProtocol {
  public let combine: (A, A) -> A
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init(combine: @escaping (A, A) -> A) {
    self.combine = combine
    self.mcombine = { accum, a in
      let result = combine(accum, a)
      accum = result
    }
  }

  public init(mcombine: @escaping (inout A, A) -> Void) {
    self.mcombine = mcombine
    self.combine = { accum, a in
      var copy = accum
      mcombine(&copy, a)
      return copy
    }
  }

  public init<S: IdempotentSemigroupProtocol>(_ s: S) where S.A == A {
    if let s = s as? IdempotentSemigroup<A> {
        self = s
    } else {
        combine = s.combine
        mcombine = s.combine
    }
  }
}
extension IdempotentSemigroup: IdempotentSemigroupInitializable { public typealias IS = IdempotentSemigroup<A> }
extension IdempotentSemigroup: IdempotentMonoidInitializable { public typealias IM = IdempotentMonoid<A> }
extension IdempotentSemigroup: CommutativeIdempotentSemigroupInitializable { public typealias CIS = CommutativeIdempotentSemigroup<A> }
extension IdempotentSemigroup: CommutativeIdempotentMonoidInitializable { public typealias CIM = CommutativeIdempotentMonoid<A> }

extension IdempotentSemigroupProtocol {
  func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> IdempotentSemigroup<B> {
    return .init(combine: { lhs, rhs in
      f(self.combine(g(lhs), g(rhs)))
    })
  }

  public var dual: IdempotentSemigroup<A> {
    return .init { self.combine($1, $0) }
  }
}

public protocol CommutativeIdempotentSemigroupProtocol: CommutativeSemigroupProtocol, IdempotentSemigroupProtocol {
    associatedtype A
}
public protocol CommutativeIdempotentSemigroupInitializable {
    associatedtype A
    associatedtype CIS: CommutativeIdempotentSemigroupProtocol
    init(_: CIS)
}
public struct CommutativeIdempotentSemigroup<A>: CommutativeIdempotentSemigroupProtocol {
  public let combine: (A, A) -> A
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init(combine: @escaping (A, A) -> A) {
    self.combine = combine
    self.mcombine = { accum, a in
      let result = combine(accum, a)
      accum = result
    }
  }

  public init(mcombine: @escaping (inout A, A) -> Void) {
    self.mcombine = mcombine
    self.combine = { accum, a in
      var copy = accum
      mcombine(&copy, a)
      return copy
    }
  }

  public init<S: CommutativeIdempotentSemigroupProtocol>(_ s: S) where S.A == A {
    if let s = s as? CommutativeIdempotentSemigroup<A> {
        self = s
    } else {
        combine = s.combine
        mcombine = s.combine
    }
  }
}
extension CommutativeIdempotentSemigroup: CommutativeIdempotentSemigroupInitializable {
    public typealias CIS = CommutativeIdempotentSemigroup<A>
}
extension CommutativeIdempotentSemigroup: CommutativeIdempotentMonoidInitializable {
    public typealias CIM = CommutativeIdempotentMonoid<A>
}

extension CommutativeIdempotentSemigroupProtocol {
  func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> CommutativeIdempotentSemigroup<B> {
    return .init(combine: { lhs, rhs in
      f(self.combine(g(lhs), g(rhs)))
    })
  }

  public var dual: CommutativeIdempotentSemigroup<A> {
    return .init { self.combine($1, $0) }
  }
}

public protocol CommutativeMonoidProtocol: CommutativeSemigroupProtocol, MonoidProtocol {
    associatedtype A
}
public protocol CommutativeMonoidInitializable {
    associatedtype A
    associatedtype CM: CommutativeMonoidProtocol
    init(_: CM)
}
public struct CommutativeMonoid<A>: CommutativeMonoidProtocol, CommutativeMonoidInitializable {
  public typealias CM = CommutativeMonoid<A>

  // Law: `combine(a, b) == combine(b, a)` for all `a, b: A`.
  public let empty: A
  public let combine: (A, A) -> A
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init(empty: A, combine: @escaping (A, A) -> A) {
    self.empty = empty
    self.combine = combine
    self.mcombine = { lhs, rhs in lhs = combine(lhs, rhs) }
  }

  public init(empty: A, mcombine: @escaping (inout A, A) -> Void) {
    self.empty = empty
    self.mcombine = mcombine
    self.combine = { lhs, rhs in var lhs = lhs; mcombine(&lhs, rhs); return lhs }
  }

  public init(empty: A, semigroup: Semigroup<A>) {
    self.empty = empty
    self.combine = semigroup.combine
    self.mcombine = semigroup.mcombine
  }

  public init(monoid: Monoid<A>) {
    self.init(empty: monoid.empty, semigroup: monoid.semigroup)
  }

  public init<M: CommutativeMonoidProtocol>(_ m: M) where M.A == A {
    if let m = m as? CommutativeMonoid<A> {
        self = m
    } else {
        empty = m.empty
        combine = m.combine
        mcombine = m.combine
    }
  }
}
extension CommutativeMonoid: CommutativeIdempotentMonoidInitializable { public typealias CIM = CommutativeIdempotentMonoid<A> }

extension CommutativeMonoidProtocol {
  public func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> CommutativeMonoid<B> {
    return CommutativeMonoid<B>(empty: f(self.empty), semigroup: self.semigroup.imap(f, g))
  }

  public var dual: CommutativeMonoid<A> {
    return CommutativeMonoid(monoid: self.monoid.dual)
  }
}

public protocol IdempotentMonoidProtocol: IdempotentSemigroupProtocol, MonoidProtocol {
    associatedtype A
}
public protocol IdempotentMonoidInitializable {
    associatedtype A
    associatedtype IM: IdempotentMonoidProtocol
    init(_: IM)
}
public struct IdempotentMonoid<A>: IdempotentMonoidProtocol, IdempotentMonoidInitializable {
  public typealias IM = IdempotentMonoid<A>

  // Law: `combine(a, a) == a` for all `a: A`
  public let empty: A
  public let combine: (A, A) -> A
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init(empty: A, combine: @escaping (A, A) -> A) {
    self.empty = empty
    self.combine = combine
    self.mcombine = { lhs, rhs in lhs = combine(lhs, rhs) }
  }

  public init(empty: A, mcombine: @escaping (inout A, A) -> Void) {
    self.empty = empty
    self.mcombine = mcombine
    self.combine = { lhs, rhs in var lhs = lhs; mcombine(&lhs, rhs); return lhs }
  }

  public init(empty: A, semigroup: Semigroup<A>) {
    self.empty = empty
    self.combine = semigroup.combine
    self.mcombine = semigroup.mcombine
  }

  public init(monoid: Monoid<A>) {
    self.init(empty: monoid.empty, semigroup: monoid.semigroup)
  }

  public init<M: IdempotentMonoidProtocol>(_ m: M) where M.A == A {
    if let m = m as? IdempotentMonoid<A> {
        self = m
    } else {
        empty = m.empty
        combine = m.combine
        mcombine = m.combine
    }
  }
}
extension IdempotentMonoid: CommutativeIdempotentMonoidInitializable { public typealias CIM = CommutativeIdempotentMonoid<A> }

extension IdempotentMonoidProtocol {
  public func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> Monoid<B> {
    return Monoid<B>(empty: f(self.empty), semigroup: self.semigroup.imap(f, g))
  }

  public var dual: IdempotentMonoid<A> {
    return IdempotentMonoid(monoid: self.monoid.dual)
  }
}

public protocol CommutativeIdempotentMonoidProtocol: CommutativeIdempotentSemigroupProtocol, CommutativeMonoidProtocol, IdempotentMonoidProtocol {
    associatedtype A
}
public protocol CommutativeIdempotentMonoidInitializable {
    associatedtype A
    associatedtype CIM: CommutativeIdempotentMonoidProtocol
    init(_: CIM)
}
public struct CommutativeIdempotentMonoid<A>: CommutativeIdempotentMonoidProtocol, CommutativeIdempotentMonoidInitializable {
  public typealias CIM = CommutativeIdempotentMonoid<A>

  // Law: `combine(a, a) == a` for all `a: A`
  public let empty: A
  public let combine: (A, A) -> A
  public let mcombine: (inout A, A) -> Void

  public func combine(_ lhs: inout A, _ rhs: A) -> Void {
    mcombine(&lhs, rhs)
  }

  public init(empty: A, combine: @escaping (A, A) -> A) {
    self.empty = empty
    self.combine = combine
    self.mcombine = { lhs, rhs in lhs = combine(lhs, rhs) }
  }

  public init(empty: A, mcombine: @escaping (inout A, A) -> Void) {
    self.empty = empty
    self.mcombine = mcombine
    self.combine = { lhs, rhs in var lhs = lhs; mcombine(&lhs, rhs); return lhs }
  }

  public init(empty: A, semigroup: Semigroup<A>) {
    self.empty = empty
    self.combine = semigroup.combine
    self.mcombine = semigroup.mcombine
  }

  public init(monoid: Monoid<A>) {
    self.init(empty: monoid.empty, semigroup: monoid.semigroup)
  }

  public init<M: CommutativeIdempotentMonoidProtocol>(_ m: M) where M.A == A {
    if let m = m as? CommutativeIdempotentMonoid<A> {
        self = m
    } else {
        empty = m.empty
        combine = m.combine
        mcombine = m.combine
    }
  }
}

extension CommutativeIdempotentMonoidProtocol {
  public func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> CommutativeIdempotentMonoid<B> {
    return CommutativeIdempotentMonoid<B>(empty: f(self.empty), semigroup: self.semigroup.imap(f, g))
  }

  public var dual: CommutativeIdempotentMonoid<A> {
    return CommutativeIdempotentMonoid(monoid: self.monoid.dual)
  }
}

public struct Semiring<A> {
  public let add: CommutativeMonoid<A>
  public let multiply: Monoid<A>

  public var one: A { return self.multiply.empty }
  public var zero: A { return self.add.empty }
}
