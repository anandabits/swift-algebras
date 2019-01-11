extension SemigroupProtocol {
  public func fold<S: Sequence>(_ initialValue: S.Element, _ xs: S) -> A where S.Element == A {
    return self.foldMap({ $0 })(initialValue, xs)
  }

  // note: The comment below in the original version was becuase you did not use `f`
  //       I am not sure exactly what your intent was so i'm guessing in the code below
  // TODO: it should be possible to get rid of `where S.Element == A`
  public func foldMap<S: Sequence>(_ f: @escaping (S.Element) -> A) -> (A, S) -> A {
    return { initialValue, xs in
      return Monoid<A>(empty: initialValue, semigroup: self).foldMap(f)(xs)
    }
  }
}

extension MonoidProtocol {
  public func fold<S: Sequence>(_ xs: S) -> A where S.Element == A {
    return foldMap({ $0 })(xs)
  }
  public func foldMap<S: Sequence>(_ f: @escaping (S.Element) -> A) -> (S) -> A {
    return { xs in
      xs.reduce(into: self.empty) { accum, x in self.combine(&accum, f(x)) }
    }
  }
}

// TODO: parallel foldMap?

extension Sequence {
  // keeping the original overlaods to support dot shorthand
  // hopefully someday dot shorthand will be supported in generic type contexts
  // and this overload set could be dropped
  public func fold(_ semigroup: Semigroup<Element>, _ initialValue: Element) -> Element {
    return semigroup.fold(initialValue, self)
  }

  public func fold( _ monoid: Monoid<Element>) -> Element {
    return monoid.fold(self)
  }

  public func foldMap<A>(_ monoid: Monoid<A>, _ f: @escaping (Element) -> A) -> (Self) -> A {
    return { xs in
      xs.reduce(into: monoid.empty) { accum, x in monoid.mcombine(&accum, f(x)) }
    }
  }

  // adding the generic overloads to handle monoid values that are not type erased
  // this could be dropped in favor of type-erasing projections defined in protocol extensions
  // if you don't mind `myValue.semigroup` at the call site
  // dual overloads keep the boilerplate in the library and can be dropped evenutally when dot shorthand
  // works in generic type contexts like this
  public func fold<S: SemigroupProtocol>(_ semigroup: S, _ initialValue: Element) -> Element where S.A == Element {
    return semigroup.fold(initialValue, self)
  }

  public func fold<M: MonoidProtocol>( _ monoid: M) -> Element where M.A == Element {
    return monoid.fold(self)
  }

  public func foldMap<M: MonoidProtocol>(_ monoid: M, _ f: @escaping (Element) -> M.A) -> (Self) -> M.A{
    return { xs in
      xs.reduce(into: monoid.empty) { accum, x in monoid.combine(&accum, f(x)) }
    }
  }
}
