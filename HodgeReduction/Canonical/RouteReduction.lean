/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Canonical.FullHodgeGoal

/-!
# A kernel-checked route-cover reduction

This file contains the part of the former Mumford--Tate programme that is
valid independently of any geometric classification claim.  At a fixed
variety and codimension, a proposed reduction must provide actual submodules
of Hodge classes, prove that they cover every Hodge class, and prove that each
retained route submodule is algebraic.  A residual submodule is kept explicit.
-/

namespace HodgeReduction.Canonical

open Infrastructure.HodgeStructure

/-- Rational submodules of the degree `2p` cohomology carried by `X`. -/
abbrev DegreeSubmodule
    (X : SmoothProjectiveComplexVarietyData) (p : Nat) :=
  @Submodule ℚ (X.cohomology.H (2 * p)) _
    (X.cohomology.addCommGroup (2 * p)).toAddCommMonoid
    (X.cohomology.module (2 * p))

/-- A completely generic route cover at one variety and codimension. -/
structure RouteCoverAt
    (X : SmoothProjectiveComplexVarietyData) (p : Nat) where
  Route : Type
  routePart : Route → DegreeSubmodule X p
  coversHodgeClasses :
    X.cohomology.hodgeClassesAtDegree p ≤ ⨆ route, routePart route

/-- A route cover proves HC at `(X,p)` once every route part is algebraic. -/
theorem hodgeConjectureRealAt_of_routeCover
    {X : SmoothProjectiveComplexVarietyData} {p : Nat}
    (D : RouteCoverAt X p)
    (routeAlgebraic :
      ∀ route, D.routePart route ≤ X.algebraicClasses.algClasses p) :
    HodgeConjectureRealAt X p := by
  exact D.coversHodgeClasses.trans (iSup_le routeAlgebraic)

/-- Route names retained from the old manuscript as an indexing device only.
The constructors assert neither coverage nor algebraicity. -/
inductive KnownMTRoute
  | lefschetz
  | abelianMotive
  | orthogonalCorrespondence
  | exceptionalE6
  | exceptionalE7
  deriving Repr, DecidableEq, Inhabited

/-- An honest MT-shaped reduction package at one variety and codimension.

`coversHodgeClasses` and `knownRouteAlgebraic` are mathematical obligations,
not consequences of the route names.  Anything not covered by a proved known
route remains in `residualPart`. -/
structure MTRouteReductionAt
    (X : SmoothProjectiveComplexVarietyData) (p : Nat) where
  knownPart : KnownMTRoute → DegreeSubmodule X p
  residualPart : DegreeSubmodule X p
  coversHodgeClasses :
    X.cohomology.hodgeClassesAtDegree p ≤
      (⨆ route, knownPart route) ⊔ residualPart
  knownRouteAlgebraic :
    ∀ route, knownPart route ≤ X.algebraicClasses.algClasses p

/-- The two proof-bearing fields exposed by an MT-shaped package. -/
theorem mtRouteReductionAt_spec
    {X : SmoothProjectiveComplexVarietyData} {p : Nat}
    (D : MTRouteReductionAt X p) :
    (X.cohomology.hodgeClassesAtDegree p ≤
      (⨆ route, D.knownPart route) ⊔ D.residualPart) ∧
    (∀ route, D.knownPart route ≤ X.algebraicClasses.algClasses p) :=
  ⟨D.coversHodgeClasses, D.knownRouteAlgebraic⟩

/-- The residual is the only remaining obligation after a valid MT-shaped
package has supplied both coverage and known-route algebraicity. -/
theorem hodgeConjectureRealAt_of_mtRouteReduction
    {X : SmoothProjectiveComplexVarietyData} {p : Nat}
    (D : MTRouteReductionAt X p)
    (residualAlgebraic :
      D.residualPart ≤ X.algebraicClasses.algClasses p) :
    HodgeConjectureRealAt X p := by
  exact D.coversHodgeClasses.trans <|
    sup_le (iSup_le D.knownRouteAlgebraic) residualAlgebraic

/-- Relative full-HC consumer.  This theorem does not construct the reduction
packages or solve their residuals; it proves that those typed obligations are
sufficient. -/
theorem fullHodgeConjectureReal_of_mtRouteReductions
    (U : SmoothProjectiveComplexUniverse)
    (D : ∀ (X : U.Variety) (p : Nat), MTRouteReductionAt (U.data X) p)
    (residualAlgebraic :
      ∀ (X : U.Variety) (p : Nat),
        (D X p).residualPart ≤ (U.data X).algebraicClasses.algClasses p) :
    FullHodgeConjectureReal U := by
  intro X
  exact (hodgeConjectureRealFor_iff_forall_at (U.data X)).mpr fun p =>
    hodgeConjectureRealAt_of_mtRouteReduction
      (D X p) (residualAlgebraic X p)

/-- Target schema for the first genuine gap: constructing a typed route
package for every variety and codimension in a supplied universe. -/
abbrev MTRouteCoverageTarget (U : SmoothProjectiveComplexUniverse) : Prop :=
  ∀ (X : U.Variety) (p : Nat),
    Nonempty (MTRouteReductionAt (U.data X) p)

/-- Target schema for the second genuine gap after packages are constructed:
algebraicity of every explicitly retained residual submodule. -/
abbrev MTResidualAlgebraicityTarget
    (U : SmoothProjectiveComplexUniverse)
    (D : ∀ (X : U.Variety) (p : Nat), MTRouteReductionAt (U.data X) p) : Prop :=
  ∀ (X : U.Variety) (p : Nat),
    (D X p).residualPart ≤ (U.data X).algebraicClasses.algClasses p

end HodgeReduction.Canonical
