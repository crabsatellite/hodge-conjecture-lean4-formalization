/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Main-theorem input status carriers

Master tex labels:

* `hyp:CM-correspondences`
* `input:motivic-span`
* `cor:Ab_covers`
* `hyp:KS-p3`
* `thm:AHD`
* `thm:GLB_full`
* `cor:Orth_covers`

These declarations record dependency shape for the early main-theorem
inputs.  They do not prove the Hodge conjecture, do not construct the
CM-CY3 correspondence, do not construct the `KS-(p,3)` extension, and do
not formalize the full AHD/GLB geometry.  They are kernel-only audit
objects whose purpose is to keep the master paper's conditional inputs
mapped to explicit Lean declarations.
-/

namespace HodgeReduction

/-- Dependency boundary for `hyp:CM-correspondences`. -/
structure RankTwoCMCY3CorrespondenceData where
  labelledCMCY3CorrespondenceHypothesis : Prop
  sameImaginaryQuadraticCMField : Prop
  sameCMType : Prop
  homHodgeClassOnProduct : Prop
  blasiusCriticalLValueAlgebraicity : Prop
  deligneAbsoluteHodgeForAbelianVarieties : Prop
  algebraicCycleRealisesHomClass : Prop
  correspondence_from_hypothesis :
    labelledCMCY3CorrespondenceHypothesis ->
      sameImaginaryQuadraticCMField ->
        sameCMType ->
          homHodgeClassOnProduct ->
            algebraicCycleRealisesHomClass

namespace RankTwoCMCY3CorrespondenceData

/-- The labelled CM-CY3 correspondence hypothesis supplies the algebraic
cycle realising the Hom-Hodge class once the rank-2 CM-CY3 situation is
in scope. -/
theorem algebraicity_from_rank_two_cm_cy3_hypothesis
    (D : RankTwoCMCY3CorrespondenceData)
    (hHyp : D.labelledCMCY3CorrespondenceHypothesis)
    (hK : D.sameImaginaryQuadraticCMField)
    (hType : D.sameCMType)
    (hHom : D.homHodgeClassOnProduct) :
    D.algebraicCycleRealisesHomClass :=
  D.correspondence_from_hypothesis hHyp hK hType hHom

end RankTwoCMCY3CorrespondenceData

/-- A model in which the cited Blasius/Deligne-style background is present
but the actual codimension-3 CM-CY3 correspondence cycle is absent. -/
def cmCY3BackgroundWithoutCorrespondenceCountermodel :
    RankTwoCMCY3CorrespondenceData where
  labelledCMCY3CorrespondenceHypothesis := False
  sameImaginaryQuadraticCMField := True
  sameCMType := True
  homHodgeClassOnProduct := True
  blasiusCriticalLValueAlgebraicity := True
  deligneAbsoluteHodgeForAbelianVarieties := True
  algebraicCycleRealisesHomClass := False
  correspondence_from_hypothesis := fun hHyp _ _ _ => False.elim hHyp

/-- Blasius critical-value algebraicity and Deligne absolute-Hodge input
do not by themselves close the CM-CY3 correspondence hypothesis. -/
theorem blasius_deligne_do_not_self_close_cm_cy3_correspondence :
    Not
      (forall D : RankTwoCMCY3CorrespondenceData,
        D.blasiusCriticalLValueAlgebraicity ->
          D.deligneAbsoluteHodgeForAbelianVarieties ->
            D.sameImaginaryQuadraticCMField ->
              D.sameCMType ->
                D.homHodgeClassOnProduct ->
                  D.algebraicCycleRealisesHomClass) := by
  intro h
  exact h cmCY3BackgroundWithoutCorrespondenceCountermodel
    trivial trivial trivial trivial trivial

/-- Dependency boundary for `input:motivic-span`. -/
structure MotivicSpanData where
  cmCY3CorrespondenceInput : Prop
  motivicSpanForRigidNonAbelianCMSubcase : Prop
  rigidNonAbelianCMSubcaseCovered : Prop
  rigid_subcase_from_span :
    cmCY3CorrespondenceInput ->
      motivicSpanForRigidNonAbelianCMSubcase ->
        rigidNonAbelianCMSubcaseCovered

namespace MotivicSpanData

/-- The rigid non-abelian CM subcase is covered only after both the CM-CY3
correspondence input and the motivic-span input are supplied. -/
theorem rigid_nonabelian_cm_subcase_from_motivic_span
    (D : MotivicSpanData)
    (hCM : D.cmCY3CorrespondenceInput)
    (hSpan : D.motivicSpanForRigidNonAbelianCMSubcase) :
    D.rigidNonAbelianCMSubcaseCovered :=
  D.rigid_subcase_from_span hCM hSpan

end MotivicSpanData

/-- A model where the CM correspondence input is present but the motivic-span
statement used by the scoped route is absent. -/
def cmCorrespondenceWithoutMotivicSpanCountermodel : MotivicSpanData where
  cmCY3CorrespondenceInput := True
  motivicSpanForRigidNonAbelianCMSubcase := False
  rigidNonAbelianCMSubcaseCovered := False
  rigid_subcase_from_span := fun _ hSpan => False.elim hSpan

/-- The CM-CY3 correspondence input alone does not close the separate
motivic-span obligation for the rigid non-abelian CM subcase. -/
theorem cm_correspondence_does_not_self_close_motivic_span :
    Not
      (forall D : MotivicSpanData,
        D.cmCY3CorrespondenceInput ->
          D.rigidNonAbelianCMSubcaseCovered) := by
  intro h
  exact h cmCorrespondenceWithoutMotivicSpanCountermodel trivial

/-- Dependency boundary for `cor:Ab_covers`. -/
structure AbelianTypeCoverageData where
  hcForCMAbelianVarieties : Prop
  ranCoherenceInput : Prop
  bktPSBBTAlgebraisationPackage : Prop
  hermitianSpinKugaSatakeEmbedding : Prop
  abelianTypeCoverage : Prop
  coverage_from_inputs :
    hcForCMAbelianVarieties ->
      ranCoherenceInput ->
        bktPSBBTAlgebraisationPackage ->
          hermitianSpinKugaSatakeEmbedding ->
            abelianTypeCoverage

namespace AbelianTypeCoverageData

/-- Abelian-type coverage consumes the HC/CM-Ab input, the definable
coherence/algebraisation package, and the Hermitian spin Kuga-Satake bridge. -/
theorem abelian_type_coverage_from_hc_cm_and_ran
    (D : AbelianTypeCoverageData)
    (hHC : D.hcForCMAbelianVarieties)
    (hRan : D.ranCoherenceInput)
    (hAlg : D.bktPSBBTAlgebraisationPackage)
    (hSpin : D.hermitianSpinKugaSatakeEmbedding) :
    D.abelianTypeCoverage :=
  D.coverage_from_inputs hHC hRan hAlg hSpin

end AbelianTypeCoverageData

/-- A model where HC for CM abelian varieties is available but the definable
coherence/algebraisation route required by the paper is absent. -/
def hcCMAbelianWithoutRanCoverageCountermodel : AbelianTypeCoverageData where
  hcForCMAbelianVarieties := True
  ranCoherenceInput := False
  bktPSBBTAlgebraisationPackage := False
  hermitianSpinKugaSatakeEmbedding := True
  abelianTypeCoverage := False
  coverage_from_inputs := fun _ hRan _ _ => False.elim hRan

/-- HC for CM abelian varieties alone does not self-close the abelian-type
coverage corollary as stated in the master paper. -/
theorem hc_cm_abelian_does_not_self_close_abelian_type_coverage :
    Not
      (forall D : AbelianTypeCoverageData,
        D.hcForCMAbelianVarieties ->
          D.hermitianSpinKugaSatakeEmbedding ->
            D.abelianTypeCoverage) := by
  intro h
  exact h hcCMAbelianWithoutRanCoverageCountermodel trivial trivial

/-- Dependency boundary for `hyp:KS-p3`. -/
structure KugaSatakeP3Data where
  spinEmbedding : Prop
  absCliffordMoritaPeriodicity : Prop
  weightOneHodgeHomomorphismOnCliffPlus : Prop
  polarizationCompatibility : Prop
  algebraicCorrespondenceRealisation : Prop
  ksP3ReductionToAbelianType : Prop
  ks_p3_from_full_package :
    spinEmbedding ->
      weightOneHodgeHomomorphismOnCliffPlus ->
        polarizationCompatibility ->
          algebraicCorrespondenceRealisation ->
            ksP3ReductionToAbelianType

namespace KugaSatakeP3Data

/-- The `KS-(p,3)` reduction follows from the full package postulated in the
master hypothesis, including the weight-one Hodge homomorphism and cycle-level
correspondence realisation. -/
theorem ks_p3_from_spin_hodge_and_correspondence
    (D : KugaSatakeP3Data)
    (hSpin : D.spinEmbedding)
    (hWeight : D.weightOneHodgeHomomorphismOnCliffPlus)
    (hPol : D.polarizationCompatibility)
    (hCycle : D.algebraicCorrespondenceRealisation) :
    D.ksP3ReductionToAbelianType :=
  D.ks_p3_from_full_package hSpin hWeight hPol hCycle

end KugaSatakeP3Data

/-- A model where the spin embedding and ABS Morita periodicity are available,
but the weight-one Hodge homomorphism and cycle realisation are absent. -/
def spinABSWithoutKSP3Countermodel : KugaSatakeP3Data where
  spinEmbedding := True
  absCliffordMoritaPeriodicity := True
  weightOneHodgeHomomorphismOnCliffPlus := False
  polarizationCompatibility := False
  algebraicCorrespondenceRealisation := False
  ksP3ReductionToAbelianType := False
  ks_p3_from_full_package := fun _ hWeight _ _ => False.elim hWeight

/-- Spin embedding plus Atiyah-Bott-Shapiro periodicity does not self-close
the load-bearing `KS-(p,3)` hypothesis. -/
theorem spin_abs_periodicity_does_not_self_close_ks_p3 :
    Not
      (forall D : KugaSatakeP3Data,
        D.spinEmbedding ->
          D.absCliffordMoritaPeriodicity ->
            D.ksP3ReductionToAbelianType) := by
  intro h
  exact h spinABSWithoutKSP3Countermodel trivial trivial

/-- Dependency boundary for `thm:AHD`. -/
structure AbsoluteHodgeDescentData where
  witnessLatticeHypothesis : Prop
  hodgeLocusAlgebraicity : Prop
  principleBForAbsoluteHodge : Prop
  bbtSpreadingAndDefinableGAGA : Prop
  wittIterationToSO_p2 : Prop
  hcAbelianInput : Prop
  ahdConclusion : Prop
  ahd_from_full_package :
    witnessLatticeHypothesis ->
      hodgeLocusAlgebraicity ->
        principleBForAbsoluteHodge ->
          bbtSpreadingAndDefinableGAGA ->
            wittIterationToSO_p2 ->
              hcAbelianInput ->
                ahdConclusion

namespace AbsoluteHodgeDescentData

/-- The AHD conclusion consumes the full package recorded in the master
paper: WLH, Hodge-locus algebraicity, Principle B, BBT spreading, Witt
iteration, and HC/Ab. -/
theorem ahd_from_wlh_hodge_locus_principleB_and_hcab
    (D : AbsoluteHodgeDescentData)
    (hWLH : D.witnessLatticeHypothesis)
    (hLocus : D.hodgeLocusAlgebraicity)
    (hB : D.principleBForAbsoluteHodge)
    (hBBT : D.bbtSpreadingAndDefinableGAGA)
    (hWitt : D.wittIterationToSO_p2)
    (hHCAb : D.hcAbelianInput) :
    D.ahdConclusion :=
  D.ahd_from_full_package hWLH hLocus hB hBBT hWitt hHCAb

end AbsoluteHodgeDescentData

/-- A model where HC/Ab and Hodge-locus algebraicity are present, but the
WLH/Witt and Principle-B/BBT package is absent. -/
def hcAbAndHodgeLocusWithoutAHDPackageCountermodel :
    AbsoluteHodgeDescentData where
  witnessLatticeHypothesis := False
  hodgeLocusAlgebraicity := True
  principleBForAbsoluteHodge := False
  bbtSpreadingAndDefinableGAGA := False
  wittIterationToSO_p2 := False
  hcAbelianInput := True
  ahdConclusion := False
  ahd_from_full_package := fun hWLH _ _ _ _ _ => False.elim hWLH

/-- HC/Ab plus Hodge-locus algebraicity does not self-close the AHD theorem
without the WLH/Witt and absolute-Hodge spreading package. -/
theorem hc_ab_and_hodge_locus_do_not_self_close_ahd :
    Not
      (forall D : AbsoluteHodgeDescentData,
        D.hodgeLocusAlgebraicity ->
          D.hcAbelianInput ->
            D.ahdConclusion) := by
  intro h
  exact h hcAbAndHodgeLocusWithoutAHDPackageCountermodel trivial trivial

/-- Dependency boundary for `thm:GLB_full` and `cor:Orth_covers`. -/
structure GLBOrthClosureData where
  meyerInput : Prop
  anisotropicResidueEmpty : Prop
  ahdProcedure : Prop
  ksP3BoundaryReduction : Prop
  hcAbelianInput : Prop
  glbOrthClosure : Prop
  orthogonalCoverage : Prop
  glb_from_cases :
    meyerInput ->
      anisotropicResidueEmpty ->
        ahdProcedure ->
          ksP3BoundaryReduction ->
            hcAbelianInput ->
              glbOrthClosure
  coverage_from_glb :
    glbOrthClosure ->
      orthogonalCoverage

namespace GLBOrthClosureData

/-- Integrated GLB/Orth closure combines the Meyer/aniso-empty branch, AHD,
the `KS-(p,3)` boundary reduction, and HC/Ab. -/
theorem glb_orth_from_meyer_ahd_ks_and_hcab
    (D : GLBOrthClosureData)
    (hMeyer : D.meyerInput)
    (hAniso : D.anisotropicResidueEmpty)
    (hAHD : D.ahdProcedure)
    (hKS : D.ksP3BoundaryReduction)
    (hHCAb : D.hcAbelianInput) :
    D.glbOrthClosure :=
  D.glb_from_cases hMeyer hAniso hAHD hKS hHCAb

/-- The orthogonal coverage corollary is the paper-side coverage statement
obtained from integrated GLB/Orth closure. -/
theorem orthogonal_coverage_from_glb_orth
    (D : GLBOrthClosureData)
    (hMeyer : D.meyerInput)
    (hAniso : D.anisotropicResidueEmpty)
    (hAHD : D.ahdProcedure)
    (hKS : D.ksP3BoundaryReduction)
    (hHCAb : D.hcAbelianInput) :
    D.orthogonalCoverage :=
  D.coverage_from_glb
    (D.glb_orth_from_meyer_ahd_ks_and_hcab hMeyer hAniso hAHD hKS hHCAb)

end GLBOrthClosureData

/-- A model where Meyer is available, but AHD and the `KS-(p,3)` boundary
reduction are absent. -/
def meyerWithoutAHDOrKSCountermodel : GLBOrthClosureData where
  meyerInput := True
  anisotropicResidueEmpty := True
  ahdProcedure := False
  ksP3BoundaryReduction := False
  hcAbelianInput := True
  glbOrthClosure := False
  orthogonalCoverage := False
  glb_from_cases := fun _ _ hAHD _ _ => False.elim hAHD
  coverage_from_glb := fun hGLB => False.elim hGLB

/-- Meyer/aniso-empty input alone does not self-close the integrated GLB/Orth
route, because AHD and the `KS-(p,3)` boundary remain load-bearing. -/
theorem meyer_input_does_not_self_close_glb_orth :
    Not
      (forall D : GLBOrthClosureData,
        D.meyerInput ->
          D.anisotropicResidueEmpty ->
            D.hcAbelianInput ->
              D.glbOrthClosure) := by
  intro h
  exact h meyerWithoutAHDOrKSCountermodel trivial trivial trivial

end HodgeReduction
