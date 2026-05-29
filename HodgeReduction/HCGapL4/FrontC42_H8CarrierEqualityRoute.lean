/-
# HC Gap L4 -- Front C42: H8 carrier splits as exact equalities (R583).

R582 rewrote the four Cartan carrier directions as two H8 carrier
splits:

* no extra source classes beyond `H8`, plus `h^4` in the source;
* no extra compact-dual classes beyond `H8`, plus `h^4` in compactDual.

Since `H8 = span {h^4}`, each split is equivalently the exact carrier
equality with `H8`.  This file records that equivalence and restates the
current target route with the smaller interface:

* `surjectivity_source = H8`;
* `compactDual = H8`;
* scalar-preimage surjectivity, equivalently the degree-8 target
  Hodge-sum rank.

No concrete EVII geometry is claimed here; the file only removes
unnecessary two-direction bookkeeping from the live target.
-/

import HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC42_H8CarrierEqualityRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge

section GenericH8CarrierEquality

variable {A : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]

/-- **R583 linear carrier lemma (1/8)**: the generator `h^4` lies in
the compact-dual `H8` line. -/
theorem h_pow_4_mem_H8 :
    (CompactDualData.H8 (A := A)).carrier ((KaehlerClass.h : A) ^ 4) := by
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.subset_span (by simp)

/-- **R583 linear carrier lemma (2/8)**: if a carrier is contained in
`H8` and contains `h^4`, then it is exactly `H8`. -/
theorem carrier_eq_H8_of_le_H8_h_pow_4_mem
    (P : Submodule Rat A)
    (hP_le_H8 : LE.le P (CompactDualData.H8 (A := A)))
    (hh_P : P.carrier ((KaehlerClass.h : A) ^ 4)) :
    P = CompactDualData.H8 (A := A) := by
  apply le_antisymm hP_le_H8
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.span_le.mpr (by
    intro x hx
    rw [Set.mem_singleton_iff] at hx
    rw [hx]
    exact hh_P)

/-- **R583 linear carrier lemma (3/8)**: the H8 carrier split is exactly
the equality `P = H8`. -/
theorem le_H8_and_h_pow_4_mem_iff_eq_H8
    (P : Submodule Rat A) :
    (LE.le P (CompactDualData.H8 (A := A)) ∧
      P.carrier ((KaehlerClass.h : A) ^ 4)) ↔
    P = CompactDualData.H8 (A := A) := by
  constructor
  · intro h
    exact carrier_eq_H8_of_le_H8_h_pow_4_mem (A := A) P h.1 h.2
  · intro h
    constructor
    · rw [h]
    · rw [h]
      exact h_pow_4_mem_H8 (A := A)

end GenericH8CarrierEquality

section SourceAndCompactDualEquality

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

omit [CartanCompactDualIso A] [MatsushimaCompactDualData A B] in
/-- **R583 substantive theorem (4/8)**: the source H8 split is exactly
`surjectivity_source = H8`. -/
theorem source_H8_split_iff_source_eq_H8 :
    ((LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CompactDualData.H8 (A := A))) ∧
      ((MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))) ↔
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  le_H8_and_h_pow_4_mem_iff_eq_H8
    (A := A)
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B] in
/-- **R583 substantive theorem (5/8)**: the compact-dual H8 split is
exactly `compactDual = H8`. -/
theorem compactDual_H8_split_iff_compactDual_eq_H8 :
    ((LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A))) ∧
      ((MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))) ↔
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  le_H8_and_h_pow_4_mem_iff_eq_H8
    (A := A)
    (MatsushimaCompactDualData.compactDual (A := A) (B := B))

omit [MatsushimaCompactDualData A B] in
/-- **R583 substantive theorem (6/8)**: source/Cartan two-sided
containment is exactly the source/H8 equality. -/
theorem source_cartan_containments_iff_source_eq_H8 :
    ((LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) ∧
      (LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)))) ↔
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  (HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence.source_cartan_containments_iff_source_H8_split
      (A := A) (B := B)).trans
    (source_H8_split_iff_source_eq_H8 (A := A) (B := B))

omit [MatsushimaSurjectivityData A B] in
/-- **R583 substantive theorem (7/8)**: compactDual/Cartan two-sided
containment is exactly the compactDual/H8 equality. -/
theorem compactDual_cartan_containments_iff_compactDual_eq_H8 :
    ((LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) ∧
      (LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))) ↔
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  (HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence.compactDual_cartan_containments_iff_compactDual_H8_split
      (A := A) (B := B)).trans
    (compactDual_H8_split_iff_compactDual_eq_H8 (A := A) (B := B))

end SourceAndCompactDualEquality

section BoundaryRouteFromH8Equalities

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R583 substantive theorem (8/8)**: with the carrier side stated as
exact H8 equalities, target Hodge-sum rank is equivalent to scalar
preimage surjectivity. -/
theorem target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) ↔
    (∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_H8_splits
      (A := A) (B := B)
      (by rw [hsource_eq_H8])
      (by
        rw [hsource_eq_H8]
        exact h_pow_4_mem_H8 (A := A))
      (by rw [hcompact_eq_H8])
      (by
        rw [hcompact_eq_H8]
        exact h_pow_4_mem_H8 (A := A))

def R583_substantiveTheoremCount : Nat := 8

end BoundaryRouteFromH8Equalities

end FrontC42_H8CarrierEqualityRoute
end HCGapL4
end HodgeReduction
