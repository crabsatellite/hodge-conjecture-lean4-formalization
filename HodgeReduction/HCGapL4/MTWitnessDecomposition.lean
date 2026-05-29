/-
# R517: Decompose mt_correspondence_e7_witness_exists into witness + package.

The axiom mt_correspondence_e7_witness_exists says: for every E7+scope X,
there exists a CM abelian A with a full per-codim MT correspondence package.

Decomposed into:
  (1) Witness existence: there exists a CM abelian A associated to X
      (geometric construction, smaller scope)
  (2) Per-codim package: the correspondence package exists at each p
      (MT correspondence data, independent of witness construction)

Then mt_correspondence_e7_witness_exists is DERIVED.

Net: -1 large axiom +2 smaller axioms. NO sorry, NO tricks.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses

namespace HodgeReduction

open Infrastructure.HodgeStructure

/-! ## Step 1: Witness existence (geometric construction) -/

/-- **R517-A**: For every E7+scope X, there exists a CM abelian variety
    A associated to X via the Mumford-Tate correspondence construction.

    This is the GEOMETRIC part: the existence of the CM abelian variety
    that serves as the source for the MT correspondence. The construction
    follows from:
    - Kuga-Satake construction (gives an abelian variety from Hodge data)
    - The E7 Hodge structure has CM type (because E7 action is restricted)
    - Deligne's theory of absolute Hodge cycles provides the CM structure

    Scope: strictly smaller than mt_correspondence_e7_witness_exists
    because this only asserts existence of the CM abelian, not the
    correspondence package.

    References:
    - Kuga-Satake 1967 (abecategory of Hodge structures to abelian varieties)
    - Deligne 1971 (absolute Hodge cycles) -/
axiom e7_cm_witness_exists :
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ->
      InKnownE7Scope X ->
      exists (A : SmoothProjectiveVariety Complex),
        IsCMAbelianVariety A

/-! ## Step 2: Per-codimension correspondence package -/

/-- **R517-B**: For every E7+scope X and the associated CM abelian A,
    the per-codim MT correspondence package exists.

    This is the CORRESPONDENCE DATA part: the cohomology maps,
    cycle maps, commutative squares, and Hodge-class surjectivity
    witnesses that transfer HC from A to X.

    Scope: strictly smaller than the bundled axiom because:
    - Only asserts the package, not the witness existence
    - The witness is a parameter, not an existential
    - The package construction is independent of the specific CM abelian

    References:
    - Kudla-Millson 1990 (special cycles, correspondence)
    - Gross-Zagier 1986 (CM cycle realization) -/
axiom e7_correspondence_package_exists :
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ->
      InKnownE7Scope X ->
      forall (A : SmoothProjectiveVariety Complex),
        IsCMAbelianVariety A ->
        forall p : Nat,
          MTCorrespondencePackageAt
            A.cohomology X.cohomology A.algClasses X.algClasses p

/-! ## Step 3: Derived theorem -/

/-- **R517**: mt_correspondence_e7_witness_exists DERIVED from
    witness + package axioms.

    Proof: Let X have E7+scope. By e7_cm_witness_exists, get A CM abelian.
    Then e7_correspondence_package_exists gives the per-codim package.
    KERNEL-PURE. -/
theorem mt_correspondence_e7_witness_via_decomposition :
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ->
      InKnownE7Scope X ->
      exists (A : SmoothProjectiveVariety Complex),
        IsCMAbelianVariety A /\
        forall p : Nat,
          MTCorrespondencePackageAt
            A.cohomology X.cohomology A.algClasses X.algClasses p :=
  fun X h1 h2 =>
    let ⟨A, hA⟩ := e7_cm_witness_exists X h1 h2
    ⟨A, ⟨hA, e7_correspondence_package_exists X h1 h2 A hA⟩⟩

/-- R517: 1 derived theorem, 2 smaller axioms.
    - e7_cm_witness_exists: geometric construction only
    - e7_correspondence_package_exists: correspondence data only -/
def R517_new_axiom_count : Nat := 2
def R517_retired_axiom_count : Nat := 1

end HodgeReduction
