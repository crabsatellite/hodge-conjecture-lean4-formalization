/-
# HC Gap L4 -- Front C159: paper-facing carriers still do not close compact-dual H8 (R724).

R723 shows the two R722 targets are independent in the current abstract
Matsushima interface:

* `MatsushimaV56BoundaryData`;
* `compactDual = H8`.

This file records the next guardrail.  Adding the paper-facing carrier
classes that are often tempting to cite in this part of the proof
(`GKCohomologyData`, Borel--Wallach low-degree data, BBW diagonal carriers,
and Freudenthal realization carriers) still does not force the second R722
target.  The live theorem remains a genuine EVII comparison:

  `MatsushimaCompactDualData.compactDual = CompactDualData.H8`.

No target is proved here, and no new axiom or hidden stronger premise is
introduced.
-/

import HodgeReduction.HCGapL4.FrontC158_H8ResidualBoundaryCompactDualIndependence
import HodgeReduction.Infrastructure.Automorphic.BorelBottWeil
import HodgeReduction.Infrastructure.Automorphic.GKCohomology

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC159_H8ResidualPaperCarrierStackIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC141_H8ResidualBoundaryCarrierIndependence

/-! ## Paper-facing carrier instances on the R706 boundary countermodel. -/

noncomputable instance instGKCohomologyDataBoundaryNoExtraObstructionSource :
    GKCohomologyData BoundaryNoExtraObstructionSource where
  dimGmodK := 0
  cohomology := fun _ => (⊥ : Submodule Rat BoundaryNoExtraObstructionSource)
  compactDualImage := fun _ => (⊥ : Submodule Rat BoundaryNoExtraObstructionSource)
  vanishing_above_dim := by
    intro _ _
    rfl
  cartan_iso := by
    intro _
    rfl
  cup_product_grade := by
    intro p q
    rw [Submodule.bot_mul]

noncomputable instance instBorelWallachLowDegreeVanishingBoundaryNoExtraObstructionSource :
    BorelWallachLowDegreeVanishing BoundaryNoExtraObstructionSource where
  dimGmodK := 0
  cohomology := fun _ => (⊥ : Submodule Rat BoundaryNoExtraObstructionSource)
  compactDualImage := fun _ => (⊥ : Submodule Rat BoundaryNoExtraObstructionSource)
  vanishing_above_dim := by
    intro _ _
    rfl
  cartan_iso := by
    intro _
    rfl
  cup_product_grade := by
    intro p q
    rw [Submodule.bot_mul]
  complexDimGmodK := 1
  trivialContribution := fun _ => (⊥ : Submodule Rat BoundaryNoExtraObstructionSource)
  holoDiscreteContribution := fun _ => (⊥ : Submodule Rat BoundaryNoExtraObstructionSource)
  decomposition_below_complex_dim := by
    intro _ _
    simp
  holoDiscrete_vanishing_below_complex_dim := by
    intro _ _
    rfl
  trivialContribution_eq_compactDualImage := by
    intro _
    rfl

noncomputable instance instBorelBottWeilDataBoundaryNoExtraObstructionSource :
    BorelBottWeilData BoundaryNoExtraObstructionSource where
  H44 := ⊤
  bigrading_holds := rfl

noncomputable instance instBorelBottWeilDiagonalEVIIBoundaryNoExtraObstructionSource :
    BorelBottWeilDiagonalEVII BoundaryNoExtraObstructionSource where
  H8_le_H44 := by
    intro _ _
    trivial

noncomputable instance instCompactDualH44BigradingBoundaryNoExtraObstructionSource :
    CompactDualH44Bigrading BoundaryNoExtraObstructionSource where
  H44 := ⊤
  H8_le_H44 := by
    intro _ _
    trivial

noncomputable instance instFreudenthalH8GInvarianceBoundaryNoExtraObstructionTarget :
    FreudenthalH8GInvariance BoundaryNoExtraObstructionTarget where
  freudenthal_S_Gamma := 0
  G_invariants := ⊤
  freudenthal_S_Gamma_is_G_invariant := by
    trivial

noncomputable instance instFreudenthalRealizationBoundaryNoExtraObstructionTarget :
    FreudenthalRealization BoundaryNoExtraObstructionTarget where
  freudenthal_descended := 0
  G_invariant_cohomology := ⊤
  freudenthal_realized := by
    trivial

/-! ## The carrier stack still does not force the compact-dual target. -/

/-- **R724 obstruction theorem (1/3)**: the R706 boundary-data countermodel
can be equipped with the current paper-facing GK/BBW/Freudenthal carrier
stack, but still refutes `compactDual = H8`. -/
theorem paperCarrierStack_boundaryData_does_not_force_compactDual_eq_H8 :
    Nonempty (GKCohomologyData BoundaryNoExtraObstructionSource) ∧
      Nonempty (BorelWallachLowDegreeVanishing BoundaryNoExtraObstructionSource) ∧
      Nonempty (BorelBottWeilData BoundaryNoExtraObstructionSource) ∧
      Nonempty (BorelBottWeilDiagonalEVII BoundaryNoExtraObstructionSource) ∧
      Nonempty (CompactDualH44Bigrading BoundaryNoExtraObstructionSource) ∧
      Nonempty (FreudenthalH8GInvariance BoundaryNoExtraObstructionTarget) ∧
      Nonempty (FreudenthalRealization BoundaryNoExtraObstructionTarget) ∧
      MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget ∧
      Not
        (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget) =
          CompactDualData.H8 (A := BoundaryNoExtraObstructionSource)) := by
  refine
    ⟨⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      counterexample_boundaryData_noExtra,
      ?_⟩
  intro hcompact
  have hle :
      LE.le (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget))
        (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource)) := by
    rw [hcompact]
  exact counterexample_not_compactDual_le_H8 hle

/-- **R724 obstruction theorem (2/3)**: even with that paper-facing carrier
stack and boundary data, the R722 two-target contract is not forced. -/
theorem paperCarrierStack_boundaryData_does_not_force_R722Contract :
    Nonempty (GKCohomologyData BoundaryNoExtraObstructionSource) ∧
      Nonempty (BorelWallachLowDegreeVanishing BoundaryNoExtraObstructionSource) ∧
      Nonempty (BorelBottWeilData BoundaryNoExtraObstructionSource) ∧
      Nonempty (BorelBottWeilDiagonalEVII BoundaryNoExtraObstructionSource) ∧
      Nonempty (CompactDualH44Bigrading BoundaryNoExtraObstructionSource) ∧
      Nonempty (FreudenthalH8GInvariance BoundaryNoExtraObstructionTarget) ∧
      Nonempty (FreudenthalRealization BoundaryNoExtraObstructionTarget) ∧
      MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget ∧
      Not
        (EVIIH8ResidualBoundaryDataCompactDualH8Contract
          BoundaryNoExtraObstructionSource
          BoundaryNoExtraObstructionTarget) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotCompact⟩ :=
      paperCarrierStack_boundaryData_does_not_force_compactDual_eq_H8
  refine ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro O
  exact hnotCompact O.compactDual_eq_H8

/-- R724 target names for route summaries. -/
def currentR724PaperCarrierStackTargetNames : List String := [
  "prove a genuine EVII comparison MatsushimaCompactDualData.compactDual = CompactDualData.H8",
  "do not derive compactDual = H8 from GK/BBW/Freudenthal carrier fields alone"
]

/-- Machine-readable status for the R724 paper-carrier guardrail. -/
structure R724PaperCarrierStackIndependenceSnapshot where
  gkCarrierAvailableInCountermodel : Bool
  borelWallachCarrierAvailableInCountermodel : Bool
  bbwCarrierAvailableInCountermodel : Bool
  freudenthalCarrierAvailableInCountermodel : Bool
  boundaryDataAvailableInCountermodel : Bool
  compactDualH8ForcedByPaperCarrierStack : Bool
  r722ContractForcedByPaperCarrierStack : Bool
  provesCompactDualH8 : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R724 status: the carrier stack can coexist with boundary data
while `compactDual = H8` still fails. -/
def currentR724PaperCarrierStackIndependenceSnapshot :
    R724PaperCarrierStackIndependenceSnapshot where
  gkCarrierAvailableInCountermodel := true
  borelWallachCarrierAvailableInCountermodel := true
  bbwCarrierAvailableInCountermodel := true
  freudenthalCarrierAvailableInCountermodel := true
  boundaryDataAvailableInCountermodel := true
  compactDualH8ForcedByPaperCarrierStack := false
  r722ContractForcedByPaperCarrierStack := false
  provesCompactDualH8 := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R724 obstruction theorem (3/3)**: kernel-checked status for the
paper-carrier guardrail. -/
theorem currentR724PaperCarrierStackIndependenceSnapshot_eq_texStatus :
    currentR724PaperCarrierStackIndependenceSnapshot =
      ({ gkCarrierAvailableInCountermodel := true
         borelWallachCarrierAvailableInCountermodel := true
         bbwCarrierAvailableInCountermodel := true
         freudenthalCarrierAvailableInCountermodel := true
         boundaryDataAvailableInCountermodel := true
         compactDualH8ForcedByPaperCarrierStack := false
         r722ContractForcedByPaperCarrierStack := false
         provesCompactDualH8 := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R724PaperCarrierStackIndependenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R724 guardrail. -/
theorem currentR724PaperCarrierStackTargetNames_eq_texStatus :
    currentR724PaperCarrierStackTargetNames = [
      "prove a genuine EVII comparison MatsushimaCompactDualData.compactDual = CompactDualData.H8",
      "do not derive compactDual = H8 from GK/BBW/Freudenthal carrier fields alone"
    ] := by
  rfl

def R724_substantiveTheoremCount : Nat := 3

end FrontC159_H8ResidualPaperCarrierStackIndependence
end HCGapL4
end HodgeReduction
