/-
# R517/R532/R545/R549: Decompose `mt_correspondence_e7_witness_exists`.

The old `mt_correspondence_e7_witness_exists` axiom said that every
E7+scope variety `X` has a CM abelian source `A` with a full per-codim
MT correspondence package.

The decomposition is now:

1. `e7_cm_witness_exists`: the CM abelian source exists.
2. Four codimension-one component cuts for the source selected by (1):
   the Hodge morphism, algebraic-class map, commuting square, and
   Hodge-class surjectivity.
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

/-- The CM abelian witness selected by `e7_cm_witness_exists`. -/
noncomputable abbrev e7ChosenCMWitness
    (X : SmoothProjectiveVariety Complex)
    (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
    (hScope : InKnownE7Scope X) : SmoothProjectiveVariety Complex :=
  Classical.choose (e7_cm_witness_exists X hE7 hScope)

/-- The selected E7 witness is CM abelian. -/
theorem e7ChosenCMWitness_isCM
    (X : SmoothProjectiveVariety Complex)
    (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
    (hScope : InKnownE7Scope X) :
    IsCMAbelianVariety (e7ChosenCMWitness X hE7 hScope) :=
  Classical.choose_spec (e7_cm_witness_exists X hE7 hScope)

/-! ## Step 2: package for the chosen witness -/

/-- **R549-B1**: the Hodge-structure morphism component of the
codimension-one E7 -> CM correspondence package. -/
axiom e7_chosen_witness_hsm_codim1 :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X),
        let A := e7ChosenCMWitness X hE7 hScope
        letI _ := A.cohomology.addCommGroup (2 * 1)
        letI _ := A.cohomology.module (2 * 1)
        letI _ := A.cohomology.hodgeStructure (2 * 1)
        letI _ := X.cohomology.addCommGroup (2 * 1)
        letI _ := X.cohomology.module (2 * 1)
        letI _ := X.cohomology.hodgeStructure (2 * 1)
        HodgeStructureMorphism
          (A.cohomology.H (2 * 1)) (X.cohomology.H (2 * 1)) (2 * 1)

/-- **R549-B2**: the algebraic-class map component of the
codimension-one E7 -> CM correspondence package. -/
axiom e7_chosen_witness_alg_map_codim1 :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X),
        let A := e7ChosenCMWitness X hE7 hScope
        letI _ := A.cohomology.addCommGroup (2 * 1)
        letI _ := A.cohomology.module (2 * 1)
        letI _ := X.cohomology.addCommGroup (2 * 1)
        letI _ := X.cohomology.module (2 * 1)
        (↥(A.algClasses.algClasses 1)) →ₗ[ℚ] (↥(X.algClasses.algClasses 1))

/-- **R549-B3**: the commuting-square component for the chosen
codimension-one E7 -> CM correspondence package. -/
axiom e7_chosen_witness_square_codim1 :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X),
        let A := e7ChosenCMWitness X hE7 hScope
        letI _ := A.cohomology.addCommGroup (2 * 1)
        letI _ := A.cohomology.module (2 * 1)
        letI _ := A.cohomology.hodgeStructure (2 * 1)
        letI _ := X.cohomology.addCommGroup (2 * 1)
        letI _ := X.cohomology.module (2 * 1)
        letI _ := X.cohomology.hodgeStructure (2 * 1)
        ∀ z : ↥(A.algClasses.algClasses 1),
          (X.algClasses.algClasses 1).subtype
              ((e7_chosen_witness_alg_map_codim1 X hE7 hScope) z) =
            (e7_chosen_witness_hsm_codim1 X hE7 hScope).toLinearMap
              ((A.algClasses.algClasses 1).subtype z)

/-- **R549-B4**: Hodge-class surjectivity for the chosen codimension-one
E7 -> CM correspondence package. -/
axiom e7_chosen_witness_hodge_surj_codim1 :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X),
        let A := e7ChosenCMWitness X hE7 hScope
        letI _ := A.cohomology.addCommGroup (2 * 1)
        letI _ := A.cohomology.module (2 * 1)
        letI _ := A.cohomology.hodgeStructure (2 * 1)
        letI _ := X.cohomology.addCommGroup (2 * 1)
        letI _ := X.cohomology.module (2 * 1)
        letI _ := X.cohomology.hodgeStructure (2 * 1)
        PureHodgeStructure.hodgeClasses (X.cohomology.H (2 * 1)) 1 ≤
          Submodule.map
            (e7_chosen_witness_hsm_codim1 X hE7 hScope).toLinearMap
            (PureHodgeStructure.hodgeClasses (A.cohomology.H (2 * 1)) 1)

/-- **R545/R549-B**: The codimension-one MT correspondence package exists
for the CM abelian source selected by `e7_cm_witness_exists`.

This is the first Front-D target: construct the divisor / Chow
correspondence piece before attempting the all-codimension lift.  R549
opens the package into the four R177 witness components instead of
leaving it as a single black-box package axiom. -/
theorem e7_chosen_witness_correspondence_package_codim1_exists :
    forall (X : SmoothProjectiveVariety Complex)
      (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
      (hScope : InKnownE7Scope X),
        MTCorrespondencePackageAt
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).cohomology
          X.cohomology
          (Classical.choose (e7_cm_witness_exists X hE7 hScope)).algClasses
          X.algClasses 1 := by
  intro X hE7 hScope
  unfold MTCorrespondencePackageAt
  refine ⟨
    e7_chosen_witness_hsm_codim1 X hE7 hScope,
    e7_chosen_witness_alg_map_codim1 X hE7 hScope,
    ?_, ?_⟩
  · exact e7_chosen_witness_square_codim1 X hE7 hScope
  · exact e7_chosen_witness_hodge_surj_codim1 X hE7 hScope

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

/-- R549: one derived theorem, six smaller cuts. -/
def R517_new_axiom_count : Nat := 6
def R517_retired_axiom_count : Nat := 1

/-- R549: the codim-one package is decomposed into four component cuts. -/
def R549_codim1_component_axiom_count : Nat := 4

end HodgeReduction
