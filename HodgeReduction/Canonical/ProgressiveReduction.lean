/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Canonical.RouteReduction

/-!
# Progressive reduction certificates

The former route package allowed the entire Hodge submodule to be chosen as
the residual, so its coverage target had a trivial inhabitant.  This file
records that diagnosis in the kernel and replaces the old research contract
by finite derivations whose residual submodule must decrease strictly at
every nonterminal step.

The resulting target is deliberately honest: a complete progressive
derivation is equivalent to the relative Hodge target.  Its benefit is not a
claim of lower global difficulty, but a machine-checkable notion of local
progress which forbids a reduction step from merely renaming the original
problem.
-/

namespace HodgeReduction.Canonical

open Infrastructure.HodgeStructure

/-- The vacuous MT-shaped package: no known route contributes anything and
the residual is the whole Hodge-class submodule. -/
noncomputable def trivialMTRouteReductionAt
    (X : SmoothProjectiveComplexVarietyData) (p : Nat) :
    MTRouteReductionAt X p where
  knownPart := fun _ => ⊥
  residualPart := X.cohomology.hodgeClassesAtDegree p
  coversHodgeClasses := by simp
  knownRouteAlgebraic := fun _ => bot_le

/-- The former route-coverage target is always inhabited, independently of
any geometry.  It therefore cannot be the first genuine gap of a reduction. -/
theorem mtRouteCoverageTarget_trivial
    (U : SmoothProjectiveComplexUniverse) :
    MTRouteCoverageTarget U := by
  intro X p
  exact ⟨trivialMTRouteReductionAt (U.data X) p⟩

/-- For the vacuous package, residual algebraicity is exactly the full Hodge
target.  This pins down the sense in which the former residual merely moved
the original conjecture. -/
theorem trivialMTResidualTarget_iff_fullHodge
    (U : SmoothProjectiveComplexUniverse) :
    MTResidualAlgebraicityTarget U
      (fun X p => trivialMTRouteReductionAt (U.data X) p) ↔
      FullHodgeConjectureReal U := by
  constructor
  · intro h X
    exact (hodgeConjectureRealFor_iff_forall_at (U.data X)).mpr (h X)
  · intro h X p
    exact (hodgeConjectureRealFor_iff_forall_at (U.data X)).mp (h X) p

/-- Combined integrity verdict for the former MT targets. -/
theorem formerMTTargets_integrityVerdict
    (U : SmoothProjectiveComplexUniverse) :
    MTRouteCoverageTarget U ∧
      (MTResidualAlgebraicityTarget U
        (fun X p => trivialMTRouteReductionAt (U.data X) p) ↔
        FullHodgeConjectureReal U) :=
  ⟨mtRouteCoverageTarget_trivial U,
    trivialMTResidualTarget_iff_fullHodge U⟩

/-- One genuine progress step inside a fixed Hodge problem.

Both the newly solved piece and the next residual remain inside `current`;
together they cover it.  The solved piece is algebraic, and the next
residual is a proper submodule of `current`. -/
structure ProgressStepAt
    (X : SmoothProjectiveComplexVarietyData) (p : Nat)
    (current : DegreeSubmodule X p) where
  solvedPart : DegreeSubmodule X p
  nextPart : DegreeSubmodule X p
  solvedPart_le_current : solvedPart ≤ current
  nextPart_le_current : nextPart ≤ current
  coversCurrent : current ≤ solvedPart ⊔ nextPart
  solvedPartAlgebraic : solvedPart ≤ X.algebraicClasses.algClasses p
  strictProgress : nextPart < current

/-- The proof-bearing fields exposed by one progress step. -/
theorem progressStepAt_spec
    {X : SmoothProjectiveComplexVarietyData} {p : Nat}
    {current : DegreeSubmodule X p}
    (D : ProgressStepAt X p current) :
    D.solvedPart ≤ current ∧
    D.nextPart ≤ current ∧
    current ≤ D.solvedPart ⊔ D.nextPart ∧
    D.solvedPart ≤ X.algebraicClasses.algClasses p ∧
    D.nextPart < current :=
  ⟨D.solvedPart_le_current, D.nextPart_le_current, D.coversCurrent,
    D.solvedPartAlgebraic, D.strictProgress⟩

/-- A finite, strictly decreasing derivation of algebraicity.  The terminal
residual is bottom; every nonterminal constructor carries a `ProgressStepAt`
certificate. -/
inductive ProgressiveAlgebraicityAt
    (X : SmoothProjectiveComplexVarietyData) (p : Nat) :
    DegreeSubmodule X p → Prop
  | bottom : ProgressiveAlgebraicityAt X p ⊥
  | step {current : DegreeSubmodule X p}
      (head : ProgressStepAt X p current)
      (tail : ProgressiveAlgebraicityAt X p head.nextPart) :
      ProgressiveAlgebraicityAt X p current

/-- Every finite progressive derivation is sound: its starting submodule is
algebraic. -/
theorem progressiveAlgebraicityAt_sound
    {X : SmoothProjectiveComplexVarietyData} {p : Nat}
    {current : DegreeSubmodule X p}
    (D : ProgressiveAlgebraicityAt X p current) :
    current ≤ X.algebraicClasses.algClasses p := by
  induction D with
  | bottom => exact bot_le
  | step head _ ih =>
      exact head.coversCurrent.trans
        (sup_le head.solvedPartAlgebraic ih)

/-- A progress step cannot retain the current submodule unchanged. -/
theorem ProgressStepAt.nextPart_ne_current
    {X : SmoothProjectiveComplexVarietyData} {p : Nat}
    {current : DegreeSubmodule X p}
    (D : ProgressStepAt X p current) :
    D.nextPart ≠ current :=
  ne_of_lt D.strictProgress

/-- Typed target for a complete progressive derivation over a supplied
universe. -/
abbrev ProgressiveReductionTarget
    (U : SmoothProjectiveComplexUniverse) : Prop :=
  ∀ (X : U.Variety) (p : Nat),
    ProgressiveAlgebraicityAt (U.data X) p
      ((U.data X).cohomology.hodgeClassesAtDegree p)

/-- Progressive derivations imply the relative full Hodge target. -/
theorem fullHodgeConjectureReal_of_progressiveReductions
    (U : SmoothProjectiveComplexUniverse)
    (D : ProgressiveReductionTarget U) :
    FullHodgeConjectureReal U := by
  intro X
  exact (hodgeConjectureRealFor_iff_forall_at (U.data X)).mpr fun p =>
    progressiveAlgebraicityAt_sound (D X p)

/-- Conversely, a closed Hodge target gives a one-step progressive
derivation whenever the Hodge submodule is nonzero, and the bottom
derivation otherwise.  Thus the complete target is a progress-normal form,
not a claim to have made the global conjecture easier. -/
theorem progressiveReductionTarget_of_fullHodge
    (U : SmoothProjectiveComplexUniverse)
    (hHC : FullHodgeConjectureReal U) :
    ProgressiveReductionTarget U := by
  intro X p
  let H := (U.data X).cohomology.hodgeClassesAtDegree p
  by_cases hH : H = ⊥
  · simpa [H, hH] using
      (ProgressiveAlgebraicityAt.bottom (X := U.data X) (p := p))
  · let head : ProgressStepAt (U.data X) p H := {
      solvedPart := H
      nextPart := ⊥
      solvedPart_le_current := le_rfl
      nextPart_le_current := bot_le
      coversCurrent := by simp
      solvedPartAlgebraic :=
        (hodgeConjectureRealFor_iff_forall_at (U.data X)).mp (hHC X) p
      strictProgress := bot_lt_iff_ne_bot.mpr hH
    }
    exact ProgressiveAlgebraicityAt.step head
      (ProgressiveAlgebraicityAt.bottom (X := U.data X) (p := p))

/-- The complete progressive target is equivalent to relative full HC. -/
theorem progressiveReductionTarget_iff_fullHodge
    (U : SmoothProjectiveComplexUniverse) :
    ProgressiveReductionTarget U ↔ FullHodgeConjectureReal U := by
  exact ⟨fullHodgeConjectureReal_of_progressiveReductions U,
    progressiveReductionTarget_of_fullHodge U⟩

end HodgeReduction.Canonical
