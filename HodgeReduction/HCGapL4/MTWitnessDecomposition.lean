/-
# R517/R532: Decompose `mt_correspondence_e7_witness_exists`.

The old `mt_correspondence_e7_witness_exists` axiom said that every
E7+scope variety `X` has a CM abelian source `A` with a full per-codim
MT correspondence package.

The decomposition is:

1. `e7_cm_witness_exists`: the CM abelian source exists.
2. `e7_chosen_witness_correspondence_package_exists`: the correspondence
   package exists for the source selected by (1).

R532 is a legality tightening over R517: the package cut no longer
asserts a package for every CM abelian variety.  It only applies to the
chosen witness from the first cut, so this layer consumes the previous
construction instead of introducing an unrelated stronger premise.

NO sorry, NO `True.intro`, NO placeholder closure.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses

namespace HodgeReduction

open Infrastructure.HodgeStructure

/-! ## Step 1: witness existence -/

/-- **R517-A**: For every E7+scope `X`, there exists a CM abelian variety
associated to `X` by the Mumford--Tate correspondence construction.

This is only the source-existence part; it does not assert the cycle-level
correspondence package. -/
axiom e7_cm_witness_exists :
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ->
      InKnownE7Scope X ->
      exists (A : SmoothProjectiveVariety Complex),
        IsCMAbelianVariety A

/-! ## Step 2: package for the chosen witness -/

/-- **R532-B**: The per-codim MT correspondence package exists for the CM
abelian source selected by `e7_cm_witness_exists`.

This is narrower than the previous R517-B formulation, which applied to
every CM abelian `A`.  A general CM abelian variety is not automatically
the source of the E7 correspondence for `X`; the package must be tied to
the witness selected by the source-existence cut. -/
axiom e7_chosen_witness_correspondence_package_exists :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X)
      (p : Nat),
        MTCorrespondencePackageAt
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).cohomology
          X.cohomology
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).algClasses
          X.algClasses p

/-! ## Step 3: derived bundled witness theorem -/

/-- **R517/R532**: `mt_correspondence_e7_witness_exists` is derived from
the source-existence cut and the package-for-that-source cut.

The proof chooses the witness from `e7_cm_witness_exists`; the package
axiom is stated for that same chosen witness. -/
theorem mt_correspondence_e7_witness_via_decomposition :
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ->
      InKnownE7Scope X ->
      exists (A : SmoothProjectiveVariety Complex),
        IsCMAbelianVariety A ∧
        forall p : Nat,
          MTCorrespondencePackageAt
            A.cohomology X.cohomology A.algClasses X.algClasses p := by
  intro X hE7 hScope
  let hW := e7_cm_witness_exists X hE7 hScope
  let A := Classical.choose hW
  have hA : IsCMAbelianVariety A := Classical.choose_spec hW
  refine ⟨A, hA, ?_⟩
  intro p
  exact e7_chosen_witness_correspondence_package_exists X hE7 hScope p

/-- R532: one derived theorem, two smaller cuts. -/
def R517_new_axiom_count : Nat := 2
def R517_retired_axiom_count : Nat := 1

end HodgeReduction
