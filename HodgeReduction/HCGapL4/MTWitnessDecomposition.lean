/-
# R517/R532/R545: Decompose `mt_correspondence_e7_witness_exists`.

The old `mt_correspondence_e7_witness_exists` axiom said that every
E7+scope variety `X` has a CM abelian source `A` with a full per-codim
MT correspondence package.

The decomposition is now:

1. `e7_cm_witness_exists`: the CM abelian source exists.
2. `e7_chosen_witness_correspondence_package_codim1_exists`: the
   codimension-one correspondence package exists for the source selected
   by (1).
3. `e7_chosen_witness_correspondence_package_non_codim1_exists`: the
   remaining non-codimension-one packages exist for that same source.

The old all-codim package name is retained as a theorem assembled from
(2) and (3), so downstream consumers cannot accidentally treat the
package as an unrelated stronger premise.

R532 is a legality tightening over R517: the package cut no longer
asserts a package for every CM abelian variety.  It only applies to the
chosen witness from the first cut, so this layer consumes the previous
construction instead of introducing an unrelated stronger premise.

Audit rule: no `sorry`, no `True.intro`, no placeholder closure.
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

/-- **R545-B1**: The codimension-one MT correspondence package exists
for the CM abelian source selected by `e7_cm_witness_exists`.

This is the first Front-D target: construct the divisor / Chow
correspondence piece before attempting the all-codimension lift. -/
axiom e7_chosen_witness_correspondence_package_codim1_exists :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X),
        MTCorrespondencePackageAt
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).cohomology
          X.cohomology
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).algClasses
          X.algClasses 1

/-- **R545-B2**: The non-codimension-one MT correspondence packages
exist for the same chosen CM abelian witness.

This isolates the later lift problem instead of hiding it inside a
single all-codim axiom.  The premise `p ≠ 1` makes this cut disjoint
from the codim-one target above. -/
axiom e7_chosen_witness_correspondence_package_non_codim1_exists :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X)
      (p : Nat),
        p ≠ 1 ->
        MTCorrespondencePackageAt
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).cohomology
          X.cohomology
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).algClasses
          X.algClasses p

/-- **R545-B**: The former all-codim package cut is now a theorem
assembled from the codim-one target and the non-codim-one lift target.

This is narrower than the previous R517-B/R532-B formulation, which
hid the codim-one first attack inside a single family. -/
theorem e7_chosen_witness_correspondence_package_exists :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X)
      (p : Nat),
        MTCorrespondencePackageAt
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).cohomology
          X.cohomology
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).algClasses
          X.algClasses p := by
  intro X hE7 hScope p
  by_cases hp : p = 1
  · subst hp
    exact e7_chosen_witness_correspondence_package_codim1_exists X hE7 hScope
  · exact
      e7_chosen_witness_correspondence_package_non_codim1_exists
        X hE7 hScope p hp

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

/-- R545: one derived theorem, three smaller cuts. -/
def R517_new_axiom_count : Nat := 3
def R517_retired_axiom_count : Nat := 1

end HodgeReduction
