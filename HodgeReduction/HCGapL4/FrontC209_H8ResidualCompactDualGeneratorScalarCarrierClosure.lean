/-
# HC Gap L4 -- Front C209: compact-dual generator scalar carrier closure (R774).

R773 shows that exact image remains independent of the R772 carrier/scalar
side.  This file tightens the non-exact side of the preferred route without
claiming closure: R661 identifies `CartanH8 <= compactDual` with the concrete
membership target `h^4 in compactDual`.

The current local attack can therefore be read as:

* exact image of source invariants;
* `h^4` lies in the compact-dual carrier;
* the target-line scalar certificate.

The file proves that this lower-level generator-membership spelling feeds the
same R772 consumers.  It does not prove exact image, compact-dual generator
membership, the scalar certificate, boundary data unconditionally, or full
Hodge closure.
-/

import HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine
import HodgeReduction.HCGapL4.FrontC207_H8ResidualCartanScalarCarrierClosure

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC209_H8ResidualCompactDualGeneratorScalarCarrierClosure

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC97_H8ResidualCartanToCompactDualLine
open FrontC119_H8ResidualCartanBoundaryEquality
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC207_H8ResidualCartanScalarCarrierClosure

section CompactDualGeneratorScalarCarrierClosure

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

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R774 substantive theorem (1/8)**: the concrete compact-dual generator
membership target is exactly the Cartan-to-compactDual containment consumed by
R772. -/
theorem cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
  (cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
    (A := A) (B := B)).2 hh_compact

/-- **R774 substantive theorem (2/8)**: compact-dual generator membership plus
the scalar certificate forces the reverse compactDual-to-Cartan containment. -/
theorem compactDual_le_cartanH8_of_h_pow_four_mem_compactDual_scalarCertificate
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :=
  compactDual_le_cartanH8_of_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B)
    (cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    C

/-- **R774 substantive theorem (3/8)**: compact-dual generator membership plus
the scalar certificate closes the compactDual/Cartan carrier equality. -/
theorem compactDual_eq_cartanH8_of_h_pow_four_mem_compactDual_scalarCertificate
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
  compactDual_eq_cartanH8_of_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B)
    (cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    C

/-- **R774 substantive theorem (4/8)**: compact-dual generator membership plus
the scalar certificate closes the compactDual/H8 carrier equality. -/
theorem compactDual_eq_H8_of_h_pow_four_mem_compactDual_scalarCertificate
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  compactDual_eq_H8_of_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B)
    (cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    C

/-- **R774 substantive theorem (5/8)**: the generator-membership spelling of
the R772 non-exact side recovers source-H8. -/
theorem source_invariants_eq_H8_of_h_pow_four_mem_compactDual_scalarCertificate
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_cartanH8_le_compactDual_scalarCertificate_from_carrierClosure
    (A := A) (B := B)
    (cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    C

/-- **R774 substantive theorem (6/8)**: exact image plus the concrete
compact-dual generator target and scalar certificate feed the R684
boundary-data-plus-Cartan contract. -/
def boundaryDataCartanContract_of_exactImage_h_pow_four_mem_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B :=
  boundaryDataCartanContract_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B)
    hexact
    (cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    C

/-- **R774 substantive theorem (7/8)**: the generator-membership spelling of
the R772 three fields gives the R683 Cartan boundary-equality contract. -/
def cartanBoundaryEqualityContract_of_exactImage_h_pow_four_mem_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualCartanBoundaryEqualityContract A B :=
  cartanBoundaryEqualityContract_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B)
    hexact
    (cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    C

/-- **R774 substantive theorem (8/8)**: the R774 three fields still expose
honest boundary data directly. -/
theorem boundaryData_nonempty_of_exactImage_h_pow_four_mem_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    Nonempty (MatsushimaV56BoundaryData A B) :=
  boundaryData_nonempty_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B)
    hexact
    (cartanH8_le_compactDual_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    C

end CompactDualGeneratorScalarCarrierClosure

/-- R774 target names for route summaries. -/
def currentR774CompactDualGeneratorScalarCarrierClosureTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove h^4 in compactDual",
  "construct target-line scalar certificate"
]

/-- Machine-readable status for the R774 compact-dual-generator scalar route. -/
structure R774CompactDualGeneratorScalarCarrierClosureSnapshot where
  proofWorkObligationCount : Nat
  replacesCartanContainmentByCompactDualGeneratorMembership : Bool
  compactDualGeneratorEquivalentToCartanContainment : Bool
  compactDualGeneratorPlusScalarClosesCarrier : Bool
  exactImagePlusGeneratorAndScalarFeedsBoundaryDataCartanContract : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCompactDualGeneratorMembership : Bool
  provesScalarCertificate : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R774 status: the non-exact carrier side is now exposed as the
concrete compact-dual generator membership target, equivalent to the R772
Cartan-containment field. -/
def currentR774CompactDualGeneratorScalarCarrierClosureSnapshot :
    R774CompactDualGeneratorScalarCarrierClosureSnapshot where
  proofWorkObligationCount :=
    currentR774CompactDualGeneratorScalarCarrierClosureTargetNames.length
  replacesCartanContainmentByCompactDualGeneratorMembership := true
  compactDualGeneratorEquivalentToCartanContainment := true
  compactDualGeneratorPlusScalarClosesCarrier := true
  exactImagePlusGeneratorAndScalarFeedsBoundaryDataCartanContract := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCompactDualGeneratorMembership := false
  provesScalarCertificate := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R774 bridge. -/
theorem currentR774CompactDualGeneratorScalarCarrierClosureSnapshot_eq_texStatus :
    currentR774CompactDualGeneratorScalarCarrierClosureSnapshot =
      ({ proofWorkObligationCount := 3
         replacesCartanContainmentByCompactDualGeneratorMembership := true
         compactDualGeneratorEquivalentToCartanContainment := true
         compactDualGeneratorPlusScalarClosesCarrier := true
         exactImagePlusGeneratorAndScalarFeedsBoundaryDataCartanContract := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCompactDualGeneratorMembership := false
         provesScalarCertificate := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R774CompactDualGeneratorScalarCarrierClosureSnapshot) := by
  decide

/-- Kernel-checked target names for the R774 bridge. -/
theorem currentR774CompactDualGeneratorScalarCarrierClosureTargetNames_eq_texStatus :
    currentR774CompactDualGeneratorScalarCarrierClosureTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove h^4 in compactDual",
      "construct target-line scalar certificate"
    ] := by
  rfl

def R774_substantiveTheoremCount : Nat := 8

end FrontC209_H8ResidualCompactDualGeneratorScalarCarrierClosure
end HCGapL4
end HodgeReduction
