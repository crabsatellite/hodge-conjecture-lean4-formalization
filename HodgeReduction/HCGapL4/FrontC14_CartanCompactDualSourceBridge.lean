/-
# HC Gap L4 -- Front C14: Cartan compact-dual source bridge (R555).

R554 reduced the Matsushima boundary problem to two concrete EVII
submodule equalities.  This file advances the source side without
inventing a concrete EVII Matsushima instance:

* Cartan's trivial-module degree-8 line equals the compact-dual H8 line;
* classes in that Cartan line are algebraic whenever the compact-dual
  carrier has `CompactDualData`;
* the R554 source equality can be proved from the more primitive
  equality `surjectivity_source = MatsushimaData.source_invariants`,
  because `MatsushimaCompactDualData` already identifies source
  invariants with compact-dual cohomology.

The remaining EVII work is still honest: construct the concrete
Matsushima/cuspidal instances and prove the source/target equalities for
that concrete degree.
-/

import HodgeReduction.HCGapL4.FrontC13_MatsushimaV56BoundaryBridge
import HodgeReduction.Infrastructure.Shimura.CompactDual

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC14_CartanCompactDualSourceBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open FrontC12_V56InfrastructureProfileBridge
open FrontC13_MatsushimaV56BoundaryBridge

/-! ## Cartan line to compact-dual H8 -/

section Cartan

variable {A : Type*} [CommRing A] [Algebra ℚ A]
  [CohomologyRing A] [KaehlerClass A]
  [CompactDualData A] [CartanCompactDualIso A]

/-- **R555 substantive theorem (1/5)**: Cartan's trivial-module H8
line equals the compact-dual H8 line.  This is the theorem form of the
`CartanCompactDualIso` field consumed by the source-side route. -/
theorem cartan_trivialModuleGK_H8_eq_compactDual_H8 :
    CartanCompactDualIso.trivialModuleGK_H8 (A := A) =
      CompactDualData.H8 (A := A) :=
  CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
    (A := A)

/-- **R555 substantive theorem (2/5)**: every class in Cartan's
trivial-module H8 line is algebraic, by rewriting it to compact-dual
H8 and applying `CompactDualData.H8_classes_are_algebraic`. -/
theorem cartan_trivialModuleGK_H8_classes_are_algebraic
    (alpha : A)
    (halpha :
      alpha ∈ CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :
    CohomologyRing.IsAlgebraic alpha := by
  have halphaH8 : alpha ∈ CompactDualData.H8 (A := A) := by
    rw [cartan_trivialModuleGK_H8_eq_compactDual_H8] at halpha
    exact halpha
  exact CompactDualData.H8_classes_are_algebraic alpha halphaH8

end Cartan

/-! ## R554 source boundary reducer -/

section MatsushimaSource

variable {A B : Type*}
  [AddCommGroup A] [Module ℚ A]
  [AddCommGroup B] [Module ℚ B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R555 substantive theorem (3/5)**: the compact-dual submodule in
the Matsushima source is the designated source-invariants submodule. -/
theorem matsushima_compactDual_eq_source_invariants :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) :=
  MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)

/-- **R555 substantive theorem (4/5)**: to prove the R554 source
boundary equality it is enough to prove the more primitive equality
`surjectivity_source = source_invariants`. -/
theorem source_eq_compactDual_of_source_eq_invariants
    [MatsushimaSurjectivityData A B]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = MatsushimaData.source_invariants (A := A) (B := B) := hsource
    _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
      (matsushima_compactDual_eq_source_invariants (A := A) (B := B)).symm

/-- **R555 substantive theorem (5/5)**: rebuild R554 boundary data from
primitive source-invariant and target-invariant equalities.  This does
not close the target equality; it makes the exact next source-side
obligation audit-visible. -/
def matsushimaV56BoundaryData_of_source_target_invariants
    [MatsushimaSurjectivityData A B]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (htarget :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        MatsushimaData.target_invariants (A := A) (B := B)) :
    MatsushimaV56BoundaryData A B where
  source_eq_compactDual :=
    source_eq_compactDual_of_source_eq_invariants
      (A := A) (B := B) hsource
  target_eq_invariants := htarget

end MatsushimaSource

/-- R555 certification package, parameterised by the future concrete
Matsushima carrier.  A later EVII round should instantiate the typeclass
arguments and supply the two equalities consumed by
`matsushimaV56BoundaryData_of_source_target_invariants`. -/
structure CartanCompactDualSourceCertification
    (A B : Type*)
    [CommRing A] [Algebra ℚ A] [CohomologyRing A] [KaehlerClass A]
    [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module ℚ B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B] where
  cartanEqCompactDual :
    CartanCompactDualIso.trivialModuleGK_H8 (A := A) =
      CompactDualData.H8 (A := A)
  cartanClassesAlgebraic :
    ∀ alpha : A,
      alpha ∈ CartanCompactDualIso.trivialModuleGK_H8 (A := A) →
        CohomologyRing.IsAlgebraic alpha
  sourceEqCompactDualOfSourceInvariants :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B) →
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B)
  v56Profile : V56InfrastructureProfileCertification

/-- R555 package constructor.  It is parameterised rather than concrete:
no EVII Matsushima instance is created here. -/
def cartanCompactDualSourceCertification_current
    {A B : Type*}
    [CommRing A] [Algebra ℚ A] [CohomologyRing A] [KaehlerClass A]
    [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module ℚ B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B] :
    CartanCompactDualSourceCertification A B where
  cartanEqCompactDual :=
    cartan_trivialModuleGK_H8_eq_compactDual_H8 (A := A)
  cartanClassesAlgebraic :=
    cartan_trivialModuleGK_H8_classes_are_algebraic (A := A)
  sourceEqCompactDualOfSourceInvariants :=
    source_eq_compactDual_of_source_eq_invariants (A := A) (B := B)
  v56Profile := v56InfrastructureProfileCertification_current

def R555_substantiveTheoremCount : Nat := 5

end FrontC14_CartanCompactDualSourceBridge
end HCGapL4
end HodgeReduction
