/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Classical and external input status carriers

Master tex labels:

* `input:Ran`
* `thm:CMdensity`
* `thm:PS`
* `prop:coherence-lemma`
* `thm:Voisin_integral`
* `prop:margulis-conditional`

These declarations give the remaining master-paper claims with empty
`leanDecls` explicit Lean-side audit objects.  They do not port Oka
coherence, o-minimality, Tsimerman/Andre-Oort, Peterzil-Starchenko,
Voisin's integral counterexamples, or Margulis superrigidity to Mathlib.
They record the dependency shape consumed by the paper and keep the
paper/Lean correspondence kernel-checkable.
-/

namespace HodgeReduction

/-- Dependency boundary for `input:Ran` and `prop:coherence-lemma`. -/
structure RanCoherenceInputData where
  okaIdealSheafCoherence : Prop
  ranDefinableSyzygies : Prop
  bbtDefinableOkaCoherence : Prop
  definableChowRoute : Prop
  ominimalCellDecompositionRoute : Prop
  idealSheafCoherentAnalytic : Prop
  idealSheafDefinablyCoherent : Prop
  bbtCoherenceInputVerified : Prop
  analytic_coherence_from_oka :
    okaIdealSheafCoherence ->
      idealSheafCoherentAnalytic
  definable_coherence_from_routeA :
    idealSheafCoherentAnalytic ->
      bbtDefinableOkaCoherence ->
        idealSheafDefinablyCoherent
  definable_coherence_from_routeB :
    definableChowRoute ->
      idealSheafDefinablyCoherent
  definable_coherence_from_routeC :
    ranDefinableSyzygies ->
      ominimalCellDecompositionRoute ->
        idealSheafDefinablyCoherent
  input_ran_from_definable_coherence :
    idealSheafDefinablyCoherent ->
      bbtCoherenceInputVerified

namespace RanCoherenceInputData

/-- The manuscript's coherence lemma follows from Oka plus any one of the
definable-coherence routes.  This theorem records Route A. -/
theorem coherence_lemma_from_oka_and_bbt_definable_oka
    (D : RanCoherenceInputData)
    (hOka : D.okaIdealSheafCoherence)
    (hBBT : D.bbtDefinableOkaCoherence) :
    D.idealSheafDefinablyCoherent :=
  D.definable_coherence_from_routeA (D.analytic_coherence_from_oka hOka) hBBT

/-- The verification input `input:Ran` is the downstream consumer of the
definable-coherence conclusion. -/
theorem input_ran_from_coherence_lemma
    (D : RanCoherenceInputData)
    (hDef : D.idealSheafDefinablyCoherent) :
    D.bbtCoherenceInputVerified :=
  D.input_ran_from_definable_coherence hDef

end RanCoherenceInputData

/-- A model where ordinary analytic coherence is available, but none of the
definable routes required by the BBT interface is present. -/
def okaCoherenceWithoutRanDefinabilityCountermodel :
    RanCoherenceInputData where
  okaIdealSheafCoherence := True
  ranDefinableSyzygies := False
  bbtDefinableOkaCoherence := False
  definableChowRoute := False
  ominimalCellDecompositionRoute := False
  idealSheafCoherentAnalytic := True
  idealSheafDefinablyCoherent := False
  bbtCoherenceInputVerified := False
  analytic_coherence_from_oka := fun _ => trivial
  definable_coherence_from_routeA := fun _ hBBT => False.elim hBBT
  definable_coherence_from_routeB := fun hChow => False.elim hChow
  definable_coherence_from_routeC := fun hSyzygy _ => False.elim hSyzygy
  input_ran_from_definable_coherence := fun hDef => False.elim hDef

/-- Oka analytic coherence alone does not self-close the `Ran`/BBT
definable-coherence input used by the paper. -/
theorem oka_coherence_does_not_self_close_ran_input :
    Not
      (forall D : RanCoherenceInputData,
        D.okaIdealSheafCoherence ->
          D.bbtCoherenceInputVerified) := by
  intro h
  exact h okaCoherenceWithoutRanDefinabilityCountermodel trivial

/-- Dependency boundary for `thm:CMdensity`. -/
structure CMDensityInputData where
  irreducibleSpecialSubvarietyComponent : Prop
  tsimermanAndreOortCmDensity : Prop
  cmPointsZariskiDense : Prop
  hodgeLocusComponentIsSpecial : Prop
  cmDenseInHodgeLocusComponent : Prop
  density_in_special_subvariety :
    irreducibleSpecialSubvarietyComponent ->
      tsimermanAndreOortCmDensity ->
        cmPointsZariskiDense
  density_in_hodge_locus_component :
    hodgeLocusComponentIsSpecial ->
      cmPointsZariskiDense ->
        cmDenseInHodgeLocusComponent

namespace CMDensityInputData

/-- The classical CM-density theorem supplies Zariski-density of CM points in
special subvariety components. -/
theorem cm_density_in_special_subvariety_from_tsimerman
    (D : CMDensityInputData)
    (hSpecial : D.irreducibleSpecialSubvarietyComponent)
    (hTsimerman : D.tsimermanAndreOortCmDensity) :
    D.cmPointsZariskiDense :=
  D.density_in_special_subvariety hSpecial hTsimerman

/-- The HC/Ab use additionally consumes the fact that the Hodge-locus
component is special. -/
theorem cm_density_in_hodge_locus_from_special_component
    (D : CMDensityInputData)
    (hSpecial : D.irreducibleSpecialSubvarietyComponent)
    (hTsimerman : D.tsimermanAndreOortCmDensity)
    (hHodgeSpecial : D.hodgeLocusComponentIsSpecial) :
    D.cmDenseInHodgeLocusComponent :=
  D.density_in_hodge_locus_component hHodgeSpecial
    (D.cm_density_in_special_subvariety_from_tsimerman hSpecial hTsimerman)

end CMDensityInputData

/-- A model where the Hodge-locus component is known to be special, but the
external CM-density theorem has not been supplied. -/
def specialComponentWithoutCMDensityCountermodel :
    CMDensityInputData where
  irreducibleSpecialSubvarietyComponent := True
  tsimermanAndreOortCmDensity := False
  cmPointsZariskiDense := False
  hodgeLocusComponentIsSpecial := True
  cmDenseInHodgeLocusComponent := False
  density_in_special_subvariety := fun _ hTsimerman => False.elim hTsimerman
  density_in_hodge_locus_component := fun _ hCM => False.elim hCM

/-- Specialness of a component does not self-close the CM-density input
without the external Tsimerman/Andre-Oort theorem. -/
theorem specialness_does_not_self_close_cm_density :
    Not
      (forall D : CMDensityInputData,
        D.irreducibleSpecialSubvarietyComponent ->
          D.hodgeLocusComponentIsSpecial ->
            D.cmDenseInHodgeLocusComponent) := by
  intro h
  exact h specialComponentWithoutCMDensityCountermodel trivial trivial

/-- Dependency boundary for `thm:PS`. -/
structure PeterzilStarchenkoInputData where
  ranDefinableClosedAnalyticSubset : Prop
  smoothAlgebraicAmbient : Prop
  peterzilStarchenkoAlgebraization : Prop
  subsetZariskiClosedAlgebraic : Prop
  algebraic_from_ps :
    ranDefinableClosedAnalyticSubset ->
      smoothAlgebraicAmbient ->
        peterzilStarchenkoAlgebraization ->
          subsetZariskiClosedAlgebraic

namespace PeterzilStarchenkoInputData

/-- The Peterzil-Starchenko theorem is consumed as the algebraization bridge
from definable closed analytic subsets to algebraic subsets. -/
theorem definable_closed_analytic_subset_is_algebraic
    (D : PeterzilStarchenkoInputData)
    (hDef : D.ranDefinableClosedAnalyticSubset)
    (hSmooth : D.smoothAlgebraicAmbient)
    (hPS : D.peterzilStarchenkoAlgebraization) :
    D.subsetZariskiClosedAlgebraic :=
  D.algebraic_from_ps hDef hSmooth hPS

end PeterzilStarchenkoInputData

/-- A model where definability and analytic closedness are present, but the
Peterzil-Starchenko algebraization input is absent. -/
def definableAnalyticWithoutPSCountermodel :
    PeterzilStarchenkoInputData where
  ranDefinableClosedAnalyticSubset := True
  smoothAlgebraicAmbient := True
  peterzilStarchenkoAlgebraization := False
  subsetZariskiClosedAlgebraic := False
  algebraic_from_ps := fun _ _ hPS => False.elim hPS

/-- Definable analytic closedness alone is not the algebraization theorem. -/
theorem definable_analytic_set_does_not_self_close_algebraicity :
    Not
      (forall D : PeterzilStarchenkoInputData,
        D.ranDefinableClosedAnalyticSubset ->
          D.smoothAlgebraicAmbient ->
            D.subsetZariskiClosedAlgebraic) := by
  intro h
  exact h definableAnalyticWithoutPSCountermodel trivial trivial

/-- Dependency boundary for `thm:Voisin_integral`. -/
structure VoisinIntegralCounterexampleData where
  smoothProjectiveVariety : Prop
  integralHodgeClass : Prop
  torsionFreeIntegralClass : Prop
  notRepresentableByIntegralAlgebraicCycle : Prop
  rationalHodgeConjectureTarget : Prop
  integralHodgeConjectureFails : Prop
  rationalTargetNotContradicted : Prop
  integral_failure_from_voisin :
    smoothProjectiveVariety ->
      integralHodgeClass ->
        torsionFreeIntegralClass ->
          notRepresentableByIntegralAlgebraicCycle ->
            integralHodgeConjectureFails
  rational_scope_separate_from_integral_failure :
    integralHodgeConjectureFails ->
      rationalHodgeConjectureTarget ->
        rationalTargetNotContradicted

namespace VoisinIntegralCounterexampleData

/-- Voisin's theorem is recorded as an integral-HC counterexample, not as a
counterexample to the rational Hodge conjecture target in this project. -/
theorem integral_hodge_counterexample_from_voisin
    (D : VoisinIntegralCounterexampleData)
    (hX : D.smoothProjectiveVariety)
    (hHodge : D.integralHodgeClass)
    (hFree : D.torsionFreeIntegralClass)
    (hNotCycle : D.notRepresentableByIntegralAlgebraicCycle) :
    D.integralHodgeConjectureFails :=
  D.integral_failure_from_voisin hX hHodge hFree hNotCycle

/-- The paper uses the Voisin theorem only to delimit integral versus
rational scope. -/
theorem voisin_integral_failure_does_not_contradict_rational_target
    (D : VoisinIntegralCounterexampleData)
    (hIntegral : D.integralHodgeConjectureFails)
    (hRationalTarget : D.rationalHodgeConjectureTarget) :
    D.rationalTargetNotContradicted :=
  D.rational_scope_separate_from_integral_failure hIntegral hRationalTarget

end VoisinIntegralCounterexampleData

/-- A model showing why an integral counterexample does not itself decide the
rational HC target. -/
def integralFailureWithoutRationalScopeCountermodel :
    VoisinIntegralCounterexampleData where
  smoothProjectiveVariety := True
  integralHodgeClass := True
  torsionFreeIntegralClass := True
  notRepresentableByIntegralAlgebraicCycle := True
  rationalHodgeConjectureTarget := False
  integralHodgeConjectureFails := True
  rationalTargetNotContradicted := False
  integral_failure_from_voisin := fun _ _ _ _ => trivial
  rational_scope_separate_from_integral_failure := fun _ hRat =>
    False.elim hRat

/-- Integral-HC failure alone does not supply a kernel theorem about the
project's rational-HC target; the scope separation is a separate claim. -/
theorem integral_hc_failure_alone_does_not_self_close_rational_scope :
    Not
      (forall D : VoisinIntegralCounterexampleData,
        D.integralHodgeConjectureFails ->
          D.rationalTargetNotContradicted) := by
  intro h
  exact h integralFailureWithoutRationalScopeCountermodel trivial

/-- Dependency boundary for `prop:margulis-conditional`. -/
structure MargulisConditionalData where
  monodromyImageIsLattice : Prop
  ambientGroupRealRankAtLeastTwo : Prop
  irreducibleLatticeHypothesis : Prop
  margulisArithmeticityTheorem : Prop
  margulisSuperrigidityTheorem : Prop
  monodromyArithmetic : Prop
  representationExtendsToAmbientGroup : Prop
  arithmeticity_from_margulis :
    monodromyImageIsLattice ->
      ambientGroupRealRankAtLeastTwo ->
        irreducibleLatticeHypothesis ->
          margulisArithmeticityTheorem ->
            monodromyArithmetic
  superrigidity_from_margulis :
    monodromyImageIsLattice ->
      ambientGroupRealRankAtLeastTwo ->
        irreducibleLatticeHypothesis ->
          margulisSuperrigidityTheorem ->
            representationExtendsToAmbientGroup

namespace MargulisConditionalData

/-- The arithmeticity clause of the paper's Margulis step is conditional on
the monodromy image already being a lattice. -/
theorem arithmeticity_if_monodromy_is_lattice
    (D : MargulisConditionalData)
    (hLattice : D.monodromyImageIsLattice)
    (hRank : D.ambientGroupRealRankAtLeastTwo)
    (hIrred : D.irreducibleLatticeHypothesis)
    (hMargulis : D.margulisArithmeticityTheorem) :
    D.monodromyArithmetic :=
  D.arithmeticity_from_margulis hLattice hRank hIrred hMargulis

/-- The superrigidity clause has the same lattice and rank hypotheses. -/
theorem representation_extension_if_monodromy_is_lattice
    (D : MargulisConditionalData)
    (hLattice : D.monodromyImageIsLattice)
    (hRank : D.ambientGroupRealRankAtLeastTwo)
    (hIrred : D.irreducibleLatticeHypothesis)
    (hMargulis : D.margulisSuperrigidityTheorem) :
    D.representationExtendsToAmbientGroup :=
  D.superrigidity_from_margulis hLattice hRank hIrred hMargulis

end MargulisConditionalData

/-- A model where the real-rank and Margulis theorem inputs are available, but
the monodromy image is not known to be a lattice. -/
def margulisWithoutLatticeHypothesisCountermodel :
    MargulisConditionalData where
  monodromyImageIsLattice := False
  ambientGroupRealRankAtLeastTwo := True
  irreducibleLatticeHypothesis := True
  margulisArithmeticityTheorem := True
  margulisSuperrigidityTheorem := True
  monodromyArithmetic := False
  representationExtendsToAmbientGroup := False
  arithmeticity_from_margulis := fun hLattice _ _ _ => False.elim hLattice
  superrigidity_from_margulis := fun hLattice _ _ _ => False.elim hLattice

/-- The Margulis theorem package does not self-close the paper's step unless
the monodromy image is first known to be a lattice. -/
theorem margulis_rank_inputs_do_not_self_close_without_lattice_hypothesis :
    Not
      (forall D : MargulisConditionalData,
        D.ambientGroupRealRankAtLeastTwo ->
          D.irreducibleLatticeHypothesis ->
            D.margulisArithmeticityTheorem ->
              D.margulisSuperrigidityTheorem ->
                D.monodromyArithmetic) := by
  intro h
  exact h margulisWithoutLatticeHypothesisCountermodel
    trivial trivial trivial trivial

end HodgeReduction
