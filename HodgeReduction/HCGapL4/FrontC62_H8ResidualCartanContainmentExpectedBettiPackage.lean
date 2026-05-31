/-
# HC Gap L4 -- Front C62: H8 residual Cartan-containment package (R603).

R602 packages the live expected-Betti residual as:

* `surjectivity_source = source_invariants`;
* `compactDual <= H8`;
* `h^4` lies in `compactDual`;
* `finrank target_invariants = shimuraEVIIExpectedBetti 8`.

This file rewrites that package back through the Cartan H8 line used in
R575/R576.  The equivalent paper-facing obligations are now the four
directional Cartan containments

* `surjectivity_source <= CartanH8`;
* `CartanH8 <= surjectivity_source`;
* `compactDual <= CartanH8`;
* `CartanH8 <= compactDual`;

together with the same target expected-Betti theorem.  The R577 countermodel
is kept visible: the four carrier containments alone do not force the target
rank, so this is a normalization of the residual target, not a closure.
-/

import HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage
import HodgeReduction.HCGapL4.FrontC35_SourceCartanContainments
import HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC62_H8ResidualCartanContainmentExpectedBettiPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC34_CartanContainmentsForCompactDual
open FrontC35_SourceCartanContainments
open FrontC36_TargetBettiObstruction
open FrontC61_H8ResidualCompactDualCarrierPackage

section CartanContainmentResidualPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- The Cartan-containment spelling of the R602 expected-Betti residual. -/
structure EVIIH8ResidualCartanContainmentExpectedBettiObligations where
  source_le_cartan :
    LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  cartan_le_source :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
  compactDual_le_cartan :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  cartan_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  target_expected_betti8 :
    Module.finrank (R := Rat)
      (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8

variable {A B}

/-- **R603 substantive theorem (1/10)**: the four Cartan containments plus
the target expected-Betti theorem recover the R602 compact-dual carrier
package. -/
def compactDualCarrierResidual_of_cartanContainmentResidual
    (O : EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) :
    EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B where
  source_eq_invariants :=
    surjectivity_source_eq_source_invariants_of_cartan_containments
      (A := A) (B := B)
      O.source_le_cartan
      O.cartan_le_source
      O.compactDual_le_cartan
      O.cartan_le_compactDual
  compactDual_le_H8 :=
    compactDual_le_H8_of_compactDual_le_cartan
      (A := A) (B := B) O.compactDual_le_cartan
  h_pow_four_mem_compactDual :=
    h_pow_4_mem_compactDual_of_cartan_le_compactDual
      (A := A) (B := B) O.cartan_le_compactDual
  target_expected_betti8 := O.target_expected_betti8

end CartanContainmentResidualPackage

section CartanSpanLemma

variable {A : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]

/-- **R603 substantive theorem (2/10)**: any submodule containing `h^4`
contains Cartan's degree-8 H8 line. -/
theorem cartan_le_of_h_pow_four_mem
    (S : Submodule Rat A)
    (hmem : S.carrier ((KaehlerClass.h : A) ^ 4)) :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) S := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.span_le.mpr (by
    intro x hx
    rw [Set.mem_singleton_iff] at hx
    rw [hx]
    exact hmem)

end CartanSpanLemma

section CompactDualCarrierToCartan

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- **R603 substantive theorem (3/10)**: R602 no-extra compact-dual
classes beyond `H8` give the compactDual-to-Cartan containment. -/
theorem compactDual_le_cartan_of_compactDualCarrierResidual
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  exact O.compactDual_le_H8

/-- **R603 substantive theorem (4/10)**: R602 membership of `h^4` in
compactDual gives the reverse Cartan-to-compactDual containment. -/
theorem cartan_le_compactDual_of_compactDualCarrierResidual
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
  cartan_le_of_h_pow_four_mem
    (A := A)
    (S := MatsushimaCompactDualData.compactDual (A := A) (B := B))
    O.h_pow_four_mem_compactDual

/-- **R603 substantive theorem (5/10)**: R602 source equality plus
compactDual no-extra-H8 gives the source-to-Cartan containment. -/
theorem source_le_cartan_of_compactDualCarrierResidual
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  rw [O.source_eq_invariants]
  exact
    (MatsushimaCompactDualData.source_invariants_le_compactDual
      (A := A) (B := B)).trans O.compactDual_le_H8

/-- **R603 substantive theorem (6/10)**: R602 source equality plus
membership of `h^4` in compactDual gives the Cartan-to-source containment. -/
theorem cartan_le_source_of_compactDualCarrierResidual
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) :=
  cartan_le_of_h_pow_four_mem
    (A := A)
    (S := MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
    (by
      rw [O.source_eq_invariants]
      exact
        MatsushimaCompactDualData.compactDual_le_source_invariants
          (A := A) (B := B) O.h_pow_four_mem_compactDual)

/-- **R603 substantive theorem (7/10)**: the R602 compact-dual carrier
package implies the Cartan-containment residual package. -/
def cartanContainmentResidual_of_compactDualCarrierResidual
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    EVIIH8ResidualCartanContainmentExpectedBettiObligations A B where
  source_le_cartan :=
    source_le_cartan_of_compactDualCarrierResidual (A := A) (B := B) O
  cartan_le_source :=
    cartan_le_source_of_compactDualCarrierResidual (A := A) (B := B) O
  compactDual_le_cartan :=
    compactDual_le_cartan_of_compactDualCarrierResidual (A := A) (B := B) O
  cartan_le_compactDual :=
    cartan_le_compactDual_of_compactDualCarrierResidual (A := A) (B := B) O
  target_expected_betti8 := O.target_expected_betti8

/-- **R603 substantive theorem (8/10)**: R602 and the Cartan-containment
residual package are equivalent at the inhabited-package level. -/
theorem residual_compactDualCarrier_nonempty_iff_cartanContainment_nonempty :
    Nonempty (EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) <->
      Nonempty (EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanContainmentResidual_of_compactDualCarrierResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualCarrierResidual_of_cartanContainmentResidual
            (A := A) (B := B) O)))

end CompactDualCarrierToCartan

section Boundary

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

/-- **R603 boundary bridge (9/10)**: the Cartan-containment residual package
feeds the existing Matsushima boundary bridge by conversion to R602. -/
def matsushimaV56BoundaryData_of_cartanContainmentResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_compactDualCarrierResidual
    (A := A) (B := B)
    (compactDualCarrierResidual_of_cartanContainmentResidual
      (A := A) (B := B) O)

end Boundary

section Countermodel

/-- **R603 obstruction theorem (10/10)**: the current abstract interface plus
all four Cartan carrier containments still does not force the full
Cartan-containment residual package, because the target expected-Betti theorem
is independent of those carrier facts in the R577 countermodel. -/
theorem current_interface_with_cartanContainments_does_not_force_cartanContainmentResidual :
    ((LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget))
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))) /\
      (LE.le
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))
        (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget))) /\
      (LE.le
        (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget))
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))) /\
      (LE.le
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))
        (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget)))) /\
      Not (EVIIH8ResidualCartanContainmentExpectedBettiObligations
        TargetBettiSource TargetBettiTarget) := by
  refine And.intro ?carrierFacts ?notResidual
  · exact
      current_interface_with_four_cartan_containments_does_not_force_target_expected_betti8.1
  · intro O
    exact
      current_interface_with_four_cartan_containments_does_not_force_target_expected_betti8.2
        O.target_expected_betti8

def R603_substantiveTheoremCount : Nat := 10

end Countermodel

end FrontC62_H8ResidualCartanContainmentExpectedBettiPackage
end HCGapL4
end HodgeReduction
