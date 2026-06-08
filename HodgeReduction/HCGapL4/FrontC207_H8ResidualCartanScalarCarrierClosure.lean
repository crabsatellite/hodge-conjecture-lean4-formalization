/-
# HC Gap L4 -- Front C207: Cartan/scalar carrier closure (R772).

R771 leaves the preferred local scalar route as:

* exact image of source invariants;
* `CartanH8 <= compactDual`;
* the target-line scalar certificate.

The exact-image field is still independent in the current abstract interface.
This file proves that the other two fields are already enough to close the
carrier side: the scalar certificate gives the target-line containment, and
R680/R682 then identify `compactDual` with the Cartan H8 line.

With exact image added back, the same data gives the R684
boundary-data-plus-Cartan contract.  No exact-image theorem, Cartan
containment theorem, scalar certificate theorem, or Hodge-conjecture closure is
asserted here.
-/

import HodgeReduction.HCGapL4.FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual
import HodgeReduction.HCGapL4.FrontC120_H8ResidualBoundaryDataCartanContract
import HodgeReduction.HCGapL4.FrontC206_H8ResidualCartanScalarRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC207_H8ResidualCartanScalarCarrierClosure

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC116_H8ResidualExactImageCartanLineThreeTargetEquivalence
open FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual
open FrontC119_H8ResidualCartanBoundaryEquality
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC199_H8ResidualTargetLineSourceContainmentBridge
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC206_H8ResidualCartanScalarRoute

section CartanScalarCarrierClosure

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

/-- **R772 substantive theorem (1/8)**: the scalar certificate supplies the
older trivial-module target-line containment used by the Cartan route. -/
theorem trivialModulePart_le_h_pow_four_line_of_scalarCertificate
    (C : TargetInvariantLineScalarCertificate A B) :
    LE.le (CuspidalCohomologyData.trivialModulePart (A := B))
      (Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) :=
  trivialModulePart_le_h_pow_four_line_of_target_invariants_le_h_pow_four_line
    (A := A) (B := B)
    (target_invariants_le_h_pow_four_line_of_targetInvariantLineScalarCertificate
      (A := A) (B := B) C)

/-- **R772 substantive theorem (2/8)**: Cartan-to-compactDual containment
plus the scalar certificate forces the reverse compactDual-to-Cartan
containment. -/
theorem compactDual_le_cartanH8_of_cartanH8_le_compactDual_scalarCertificate
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :=
  compactDual_le_cartanH8_of_cartanH8_le_compactDual_and_targetLine
    (A := A) (B := B)
    hcartan
    (trivialModulePart_le_h_pow_four_line_of_scalarCertificate
      (A := A) (B := B) C)

/-- **R772 substantive theorem (3/8)**: Cartan-to-compactDual containment
plus scalar certificate closes the compactDual/Cartan carrier equality. -/
theorem compactDual_eq_cartanH8_of_cartanH8_le_compactDual_scalarCertificate
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
  compactDual_eq_cartanH8_of_cartanH8_le_compactDual_and_targetLine
    (A := A) (B := B)
    hcartan
    (trivialModulePart_le_h_pow_four_line_of_scalarCertificate
      (A := A) (B := B) C)

/-- **R772 substantive theorem (4/8)**: the same two non-exact fields close
the compactDual/H8 carrier equality. -/
theorem compactDual_eq_H8_of_cartanH8_le_compactDual_scalarCertificate
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaCompactDualData.compactDual (A := A) (B := B)
        = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        compactDual_eq_cartanH8_of_cartanH8_le_compactDual_scalarCertificate
          (A := A) (B := B) hcartan C
    _ = CompactDualData.H8 (A := A) :=
        CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := A)

/-- **R772 substantive theorem (5/8)**: Cartan containment plus scalar
certificate recovers source-H8 through the R771 route. -/
theorem source_invariants_eq_H8_of_cartanH8_le_compactDual_scalarCertificate_from_carrierClosure
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  HodgeReduction.HCGapL4.FrontC206_H8ResidualCartanScalarRoute.source_invariants_eq_H8_of_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B) hcartan C

/-- **R772 substantive theorem (6/8)**: adding exact image to the R772 carrier
closure gives the R684 boundary-data-plus-Cartan contract. -/
def boundaryDataCartanContract_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B where
  boundary :=
    matsushimaV56BoundaryData_of_exactImage_cartanH8_le_compactDual_scalarCertificate
      (A := A) (B := B) hexact hcartan C
  compactDual_eq_cartanH8 :=
    compactDual_eq_cartanH8_of_cartanH8_le_compactDual_scalarCertificate
      (A := A) (B := B) hcartan C

/-- **R772 substantive theorem (7/8)**: the R772 three fields give the full
R683 Cartan boundary-equality contract. -/
def cartanBoundaryEqualityContract_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualCartanBoundaryEqualityContract A B :=
  cartanBoundaryEqualityContract_of_boundaryDataCartanContract
    (A := A) (B := B)
    (boundaryDataCartanContract_of_exactImage_cartanH8_le_compactDual_scalarCertificate
      (A := A) (B := B) hexact hcartan C)

/-- **R772 substantive theorem (8/8)**: the R772 three fields still expose
honest boundary data directly. -/
theorem boundaryData_nonempty_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    Nonempty (MatsushimaV56BoundaryData A B) :=
  Nonempty.intro
    (matsushimaV56BoundaryData_of_exactImage_cartanH8_le_compactDual_scalarCertificate
      (A := A) (B := B) hexact hcartan C)

end CartanScalarCarrierClosure

/-- R772 target names for route summaries. -/
def currentR772CartanScalarCarrierClosureTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove CartanH8 <= compactDual",
  "construct target-line scalar certificate"
]

/-- Machine-readable status for the R772 Cartan/scalar carrier closure. -/
structure R772CartanScalarCarrierClosureSnapshot where
  proofWorkObligationCount : Nat
  scalarCertificateSuppliesTargetLine : Bool
  cartanContainmentPlusScalarClosesReverseContainment : Bool
  cartanContainmentPlusScalarClosesCompactDualCartan : Bool
  cartanContainmentPlusScalarClosesCompactDualH8 : Bool
  exactImagePlusCarrierClosureFeedsBoundaryDataCartanContract : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCartanContainment : Bool
  provesScalarCertificate : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R772 status: the two non-exact R771 fields close the carrier side,
while exact image remains an independent proof-work target. -/
def currentR772CartanScalarCarrierClosureSnapshot :
    R772CartanScalarCarrierClosureSnapshot where
  proofWorkObligationCount := currentR772CartanScalarCarrierClosureTargetNames.length
  scalarCertificateSuppliesTargetLine := true
  cartanContainmentPlusScalarClosesReverseContainment := true
  cartanContainmentPlusScalarClosesCompactDualCartan := true
  cartanContainmentPlusScalarClosesCompactDualH8 := true
  exactImagePlusCarrierClosureFeedsBoundaryDataCartanContract := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCartanContainment := false
  provesScalarCertificate := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R772 bridge. -/
theorem currentR772CartanScalarCarrierClosureSnapshot_eq_texStatus :
    currentR772CartanScalarCarrierClosureSnapshot =
      ({ proofWorkObligationCount := 3
         scalarCertificateSuppliesTargetLine := true
         cartanContainmentPlusScalarClosesReverseContainment := true
         cartanContainmentPlusScalarClosesCompactDualCartan := true
         cartanContainmentPlusScalarClosesCompactDualH8 := true
         exactImagePlusCarrierClosureFeedsBoundaryDataCartanContract := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCartanContainment := false
         provesScalarCertificate := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R772CartanScalarCarrierClosureSnapshot) := by
  decide

/-- Kernel-checked target names for the R772 bridge. -/
theorem currentR772CartanScalarCarrierClosureTargetNames_eq_texStatus :
    currentR772CartanScalarCarrierClosureTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove CartanH8 <= compactDual",
      "construct target-line scalar certificate"
    ] := by
  rfl

def R772_substantiveTheoremCount : Nat := 8

end FrontC207_H8ResidualCartanScalarCarrierClosure
end HCGapL4
end HodgeReduction
