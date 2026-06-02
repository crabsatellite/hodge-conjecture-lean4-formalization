/-
# HC Gap L4 -- Front C161: paper carriers do not force Cartan containments (R726).

R725 identifies the latest non-boundary target with the Cartan/GK comparison

  `compactDual = CartanCompactDualIso.trivialModuleGK_H8`.

This file splits that equality into its two carrier directions and records
that the current paper-facing GK/Borel-Wallach/BBW/Freudenthal carrier stack
does not force either direction in the abstract interface:

* `compactDual <= CartanH8` is refuted by the R706 no-extra countermodel;
* `CartanH8 <= compactDual` is refuted by the R664 generator countermodel,
  even after equipping it with the same paper-facing carriers.

Thus the next proof must supply genuine EVII compact-dual/Cartan geometry for
both directions, or an equivalent theorem strong enough to imply both.
-/

import HodgeReduction.HCGapL4.FrontC160_H8ResidualCurrentCartanComparisonRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC161_H8ResidualPaperCarrierCartanContainmentIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC100_H8ResidualCartanContainmentIndependence
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC141_H8ResidualBoundaryCarrierIndependence
open FrontC160_H8ResidualCurrentCartanComparisonRoute

section CartanContainmentSplit

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

/-- R726 two-containment spelling of the R725 boundary-data/Cartan route. -/
structure EVIIH8ResidualBoundaryDataCartanTwoContainmentContract
    (A B : Type*)
    [CommRing A] [Algebra Rat A] [CohomologyRing A]
    [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B]
    [CuspidalCohomologyData B]
    [EisensteinVanishingDeg8 A B]
    [CuspidalGInvariantTrivialModuleDeg8 A B] where
  boundary : MatsushimaV56BoundaryData A B
  compactDual_le_cartanH8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))

/-- **R726 substantive theorem (1/8)**: a Cartan equality contract supplies
both one-sided Cartan containments. -/
def cartanTwoContainmentContract_of_currentBoundaryDataCartanContract
    (O : EVIIH8ResidualBoundaryDataCartanContract A B) :
    EVIIH8ResidualBoundaryDataCartanTwoContainmentContract A B where
  boundary := O.boundary
  compactDual_le_cartanH8 := by
    rw [O.compactDual_eq_cartanH8]
  cartanH8_le_compactDual := by
    rw [O.compactDual_eq_cartanH8]

/-- **R726 substantive theorem (2/8)**: the two Cartan containments rebuild
the R725 Cartan equality contract, so the split adds no stronger premise. -/
def currentBoundaryDataCartanContract_of_cartanTwoContainmentContract
    (O : EVIIH8ResidualBoundaryDataCartanTwoContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B where
  boundary := O.boundary
  compactDual_eq_cartanH8 :=
    le_antisymm O.compactDual_le_cartanH8 O.cartanH8_le_compactDual

/-- **R726 substantive theorem (3/8)**: the R725 Cartan comparison route and
the two-containment Cartan route are the same inhabited residual contract. -/
theorem residual_currentBoundaryDataCartan_nonempty_iff_cartanTwoContainment_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCartanTwoContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanTwoContainmentContract_of_currentBoundaryDataCartanContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (currentBoundaryDataCartanContract_of_cartanTwoContainmentContract
            (A := A) (B := B) O)))

end CartanContainmentSplit

/-! ## Paper-facing carriers on the R664 generator countermodel. -/

noncomputable instance instGKCohomologyDataCartanContainmentObstructionSource :
    GKCohomologyData CartanContainmentObstructionSource where
  dimGmodK := 0
  cohomology := fun _ => (⊥ : Submodule Rat CartanContainmentObstructionSource)
  compactDualImage := fun _ => (⊥ : Submodule Rat CartanContainmentObstructionSource)
  vanishing_above_dim := by
    intro _ _
    rfl
  cartan_iso := by
    intro _
    rfl
  cup_product_grade := by
    intro p q
    rw [Submodule.bot_mul]

noncomputable instance instBorelWallachLowDegreeVanishingCartanContainmentObstructionSource :
    BorelWallachLowDegreeVanishing CartanContainmentObstructionSource where
  dimGmodK := 0
  cohomology := fun _ => (⊥ : Submodule Rat CartanContainmentObstructionSource)
  compactDualImage := fun _ => (⊥ : Submodule Rat CartanContainmentObstructionSource)
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
  trivialContribution := fun _ => (⊥ : Submodule Rat CartanContainmentObstructionSource)
  holoDiscreteContribution := fun _ => (⊥ : Submodule Rat CartanContainmentObstructionSource)
  decomposition_below_complex_dim := by
    intro _ _
    simp
  holoDiscrete_vanishing_below_complex_dim := by
    intro _ _
    rfl
  trivialContribution_eq_compactDualImage := by
    intro _
    rfl

noncomputable instance instBorelBottWeilDataCartanContainmentObstructionSource :
    BorelBottWeilData CartanContainmentObstructionSource where
  H44 := ⊤
  bigrading_holds := rfl

noncomputable instance instBorelBottWeilDiagonalEVIICartanContainmentObstructionSource :
    BorelBottWeilDiagonalEVII CartanContainmentObstructionSource where
  H8_le_H44 := by
    intro _ _
    trivial

noncomputable instance instCompactDualH44BigradingCartanContainmentObstructionSource :
    CompactDualH44Bigrading CartanContainmentObstructionSource where
  H44 := ⊤
  H8_le_H44 := by
    intro _ _
    trivial

noncomputable instance instFreudenthalH8GInvarianceCartanContainmentObstructionTarget :
    FreudenthalH8GInvariance CartanContainmentObstructionTarget where
  freudenthal_S_Gamma := 0
  G_invariants := ⊥
  freudenthal_S_Gamma_is_G_invariant := by
    trivial

noncomputable instance instFreudenthalRealizationCartanContainmentObstructionTarget :
    FreudenthalRealization CartanContainmentObstructionTarget where
  freudenthal_descended := 0
  G_invariant_cohomology := ⊥
  freudenthal_realized := by
    trivial

/-- Boundary data for the R664 Cartan-to-compactDual countermodel. -/
def counterexample_boundaryData_cartanContainmentObstruction :
    MatsushimaV56BoundaryData
      CartanContainmentObstructionSource
      CartanContainmentObstructionTarget where
  source_eq_compactDual := rfl
  target_eq_invariants := rfl

/-! ## The carrier stack does not force either Cartan containment. -/

/-- **R726 substantive theorem (4/8)**: on the R706 no-extra model, the
paper-facing carrier stack plus boundary data still does not force
`compactDual <= CartanH8`. -/
theorem paperCarrierStack_boundaryData_does_not_force_compactDual_le_cartanH8 :
    Nonempty (GKCohomologyData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelWallachLowDegreeVanishing BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilDiagonalEVII BoundaryNoExtraObstructionSource) /\
      Nonempty (CompactDualH44Bigrading BoundaryNoExtraObstructionSource) /\
      Nonempty (FreudenthalH8GInvariance BoundaryNoExtraObstructionTarget) /\
      Nonempty (FreudenthalRealization BoundaryNoExtraObstructionTarget) /\
      MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      Not
        (LE.le (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget))
          (CartanCompactDualIso.trivialModuleGK_H8
            (A := BoundaryNoExtraObstructionSource))) := by
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
  intro hleCartan
  have hleH8 :
      LE.le (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget))
        (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource)) := by
    rw [← CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
      (A := BoundaryNoExtraObstructionSource)]
    exact hleCartan
  exact counterexample_not_compactDual_le_H8 hleH8

/-- **R726 substantive theorem (5/8)**: on the R664 generator model, the
same carrier stack plus boundary data still does not force
`CartanH8 <= compactDual`. -/
theorem paperCarrierStack_boundaryData_does_not_force_cartanH8_le_compactDual :
    Nonempty (GKCohomologyData CartanContainmentObstructionSource) /\
      Nonempty (BorelWallachLowDegreeVanishing CartanContainmentObstructionSource) /\
      Nonempty (BorelBottWeilData CartanContainmentObstructionSource) /\
      Nonempty (BorelBottWeilDiagonalEVII CartanContainmentObstructionSource) /\
      Nonempty (CompactDualH44Bigrading CartanContainmentObstructionSource) /\
      Nonempty (FreudenthalH8GInvariance CartanContainmentObstructionTarget) /\
      Nonempty (FreudenthalRealization CartanContainmentObstructionTarget) /\
      MatsushimaV56BoundaryData
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget /\
      Not
        (LE.le (CartanCompactDualIso.trivialModuleGK_H8
            (A := CartanContainmentObstructionSource))
          (MatsushimaCompactDualData.compactDual
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget))) := by
  exact
    ⟨⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      ⟨inferInstance⟩,
      counterexample_boundaryData_cartanContainmentObstruction,
      counterexample_not_cartanH8_le_compactDual⟩

/-- **R726 substantive theorem (6/8)**: the paper-facing carrier stack
therefore cannot close the R725 Cartan equality by proving both directions
abstractly. -/
theorem paperCarrierStack_does_not_close_both_cartan_containment_directions :
    (Not
        (LE.le (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget))
          (CartanCompactDualIso.trivialModuleGK_H8
            (A := BoundaryNoExtraObstructionSource)))) /\
      (Not
        (LE.le (CartanCompactDualIso.trivialModuleGK_H8
            (A := CartanContainmentObstructionSource))
          (MatsushimaCompactDualData.compactDual
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget)))) :=
  ⟨paperCarrierStack_boundaryData_does_not_force_compactDual_le_cartanH8.2.2.2.2.2.2.2.2,
    paperCarrierStack_boundaryData_does_not_force_cartanH8_le_compactDual.2.2.2.2.2.2.2.2⟩

/-- R726 target names for route summaries. -/
def currentR726CartanContainmentTargetNames : List String := [
  "prove compactDual <= CartanCompactDualIso.trivialModuleGK_H8",
  "prove CartanCompactDualIso.trivialModuleGK_H8 <= compactDual"
]

/-- Machine-readable status for the R726 Cartan containment split. -/
structure R726CartanContainmentIndependenceSnapshot where
  proofWorkObligationCount : Nat
  cartanEqualityEquivalentToTwoContainments : Bool
  paperCarrierStackForcesCompactDualNoExtraDirection : Bool
  paperCarrierStackForcesCartanGeneratorDirection : Bool
  introducesStrongerPremise : Bool
  provesCompactDualLeCartan : Bool
  provesCartanLeCompactDual : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R726 status: the R725 Cartan comparison splits into two open
containment targets, and the paper-facing carrier stack proves neither one
inside the current abstract interface. -/
def currentR726CartanContainmentIndependenceSnapshot :
    R726CartanContainmentIndependenceSnapshot where
  proofWorkObligationCount := currentR726CartanContainmentTargetNames.length
  cartanEqualityEquivalentToTwoContainments := true
  paperCarrierStackForcesCompactDualNoExtraDirection := false
  paperCarrierStackForcesCartanGeneratorDirection := false
  introducesStrongerPremise := false
  provesCompactDualLeCartan := false
  provesCartanLeCompactDual := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R726 substantive theorem (7/8)**: kernel-checked status for the
Cartan-containment split and carrier-stack guardrail. -/
theorem currentR726CartanContainmentIndependenceSnapshot_eq_texStatus :
    currentR726CartanContainmentIndependenceSnapshot =
      ({ proofWorkObligationCount := 2
         cartanEqualityEquivalentToTwoContainments := true
         paperCarrierStackForcesCompactDualNoExtraDirection := false
         paperCarrierStackForcesCartanGeneratorDirection := false
         introducesStrongerPremise := false
         provesCompactDualLeCartan := false
         provesCartanLeCompactDual := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R726CartanContainmentIndependenceSnapshot) := by
  decide

/-- **R726 substantive theorem (8/8)**: kernel-checked target names for the
two Cartan containment directions. -/
theorem currentR726CartanContainmentTargetNames_eq_texStatus :
    currentR726CartanContainmentTargetNames = [
      "prove compactDual <= CartanCompactDualIso.trivialModuleGK_H8",
      "prove CartanCompactDualIso.trivialModuleGK_H8 <= compactDual"
    ] := by
  rfl

def R726_substantiveTheoremCount : Nat := 8

end FrontC161_H8ResidualPaperCarrierCartanContainmentIndependence
end HCGapL4
end HodgeReduction
