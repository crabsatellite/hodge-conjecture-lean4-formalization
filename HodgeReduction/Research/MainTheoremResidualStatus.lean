/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Main-theorem residual status carriers

Master tex labels:

* `thm:generic_fiber`
* `thm:Satake_abelian_classification`
* `thm:E7_approachF`
* `thm:eigenvalue-separation`

These declarations record the dependency shape for four remaining
master-paper claims on the `G-main-hc` route.  They are audit objects:
they do not prove the cited Satake/Milne classification, do not pin the
Griffiths-Schmid normalisation constant, do not turn the Approach F
total-space class into a fibre-level cycle, and do not prove the
non-abelian Honda-Tate extension used by the appendix eigenvalue route.
-/

namespace HodgeReduction

/-- Dependency boundary for `thm:generic_fiber`. -/
structure GenericFibreInvariantData where
  offMiddlePrimitiveHodgeClassesVanish : Prop
  middlePrimitiveGeneratedByEulerInvariant : Prop
  hodgeBundleEulerChernClassIdentity : Prop
  normalisationConstantPinned : Prop
  topChernClassAlgebraic : Prop
  genericFibreInvariantTheorem : Prop
  generic_fibre_from_full_package :
    offMiddlePrimitiveHodgeClassesVanish ->
      middlePrimitiveGeneratedByEulerInvariant ->
        hodgeBundleEulerChernClassIdentity ->
          normalisationConstantPinned ->
            topChernClassAlgebraic ->
              genericFibreInvariantTheorem

namespace GenericFibreInvariantData

/-- The generic-fibre invariant statement follows only after the invariant
theory, Hodge-bundle identity, normalisation, and Chern-class algebraicity
inputs are all supplied. -/
theorem generic_fibre_invariant_from_full_package
    (D : GenericFibreInvariantData)
    (hOffMiddle : D.offMiddlePrimitiveHodgeClassesVanish)
    (hMiddle : D.middlePrimitiveGeneratedByEulerInvariant)
    (hIdentity : D.hodgeBundleEulerChernClassIdentity)
    (hNorm : D.normalisationConstantPinned)
    (hChern : D.topChernClassAlgebraic) :
    D.genericFibreInvariantTheorem :=
  D.generic_fibre_from_full_package hOffMiddle hMiddle hIdentity hNorm hChern

end GenericFibreInvariantData

/-- A model where invariant theory and Chern-class algebraicity are present,
but the paper's normalisation constant is not pinned. -/
def genericFibreNormalisationMissingCountermodel :
    GenericFibreInvariantData where
  offMiddlePrimitiveHodgeClassesVanish := True
  middlePrimitiveGeneratedByEulerInvariant := True
  hodgeBundleEulerChernClassIdentity := True
  normalisationConstantPinned := False
  topChernClassAlgebraic := True
  genericFibreInvariantTheorem := False
  generic_fibre_from_full_package := fun _ _ _ hNorm _ => False.elim hNorm

/-- The invariant-theory and Chern-class pieces do not by themselves close the
generic-fibre theorem without the Griffiths-Schmid normalisation input. -/
theorem invariant_theory_and_chern_classes_do_not_self_close_generic_fibre :
    Not
      (forall D : GenericFibreInvariantData,
        D.offMiddlePrimitiveHodgeClassesVanish ->
          D.middlePrimitiveGeneratedByEulerInvariant ->
            D.hodgeBundleEulerChernClassIdentity ->
              D.topChernClassAlgebraic ->
                D.genericFibreInvariantTheorem) := by
  intro h
  exact h genericFibreNormalisationMissingCountermodel
    trivial trivial trivial trivial

/-- Dependency boundary for `thm:Satake_abelian_classification`. -/
structure SatakeAbelianClassificationData where
  classicalTypeABCD : Prop
  exceptionalTypeEIIIOrEVII : Prop
  satakeMilneWeightCriterion : Prop
  abelianTypeHermitianDomain : Prop
  notAbelianTypeHermitianDomain : Prop
  abelian_from_classical_type :
    classicalTypeABCD ->
      satakeMilneWeightCriterion ->
        abelianTypeHermitianDomain
  exceptional_not_abelian_from_criterion :
    exceptionalTypeEIIIOrEVII ->
      satakeMilneWeightCriterion ->
        notAbelianTypeHermitianDomain

namespace SatakeAbelianClassificationData

/-- The EIII/EVII non-abelian-type conclusion is consumed through the
Satake-Milne weight criterion. -/
theorem exceptional_eiii_evii_not_abelian_type
    (D : SatakeAbelianClassificationData)
    (hExceptional : D.exceptionalTypeEIIIOrEVII)
    (hCriterion : D.satakeMilneWeightCriterion) :
    D.notAbelianTypeHermitianDomain :=
  D.exceptional_not_abelian_from_criterion hExceptional hCriterion

end SatakeAbelianClassificationData

/-- A model where the exceptional label is present but the Satake-Milne
criterion itself has not been supplied to the kernel interface. -/
def exceptionalLabelWithoutSatakeCriterionCountermodel :
    SatakeAbelianClassificationData where
  classicalTypeABCD := False
  exceptionalTypeEIIIOrEVII := True
  satakeMilneWeightCriterion := False
  abelianTypeHermitianDomain := False
  notAbelianTypeHermitianDomain := False
  abelian_from_classical_type := fun hClassical _ => False.elim hClassical
  exceptional_not_abelian_from_criterion := fun _ hCriterion =>
    False.elim hCriterion

/-- Naming EIII/EVII is not a kernel proof of the Satake-Milne classification
criterion; the classical classification remains an external theorem to port. -/
theorem exceptional_label_does_not_self_close_satake_classification :
    Not
      (forall D : SatakeAbelianClassificationData,
        D.exceptionalTypeEIIIOrEVII ->
          D.notAbelianTypeHermitianDomain) := by
  intro h
  exact h exceptionalLabelWithoutSatakeCriterionCountermodel trivial

/-- Dependency boundary for `thm:E7_approachF`. -/
structure E7ApproachFTotalSpaceData where
  e7ChernWeilBridge : Prop
  nonRigidE7Family : Prop
  compactifiedFamily : Prop
  algebraicPeriodMapToToroidalTarget : Prop
  shimuraSideAlgebraicClass : Prop
  totalSpacePullbackClass : Prop
  fibreLevelTargetClassAlgebraic : Prop
  total_space_from_chern_weil_bridge :
    e7ChernWeilBridge ->
      nonRigidE7Family ->
        compactifiedFamily ->
          algebraicPeriodMapToToroidalTarget ->
            shimuraSideAlgebraicClass ->
              totalSpacePullbackClass

namespace E7ApproachFTotalSpaceData

/-- Approach F constructs the total-space pullback class from the Chern-Weil
bridge and non-rigid family package. -/
theorem total_space_class_from_chern_weil_bridge
    (D : E7ApproachFTotalSpaceData)
    (hCW : D.e7ChernWeilBridge)
    (hFamily : D.nonRigidE7Family)
    (hCompact : D.compactifiedFamily)
    (hPeriod : D.algebraicPeriodMapToToroidalTarget)
    (hShimura : D.shimuraSideAlgebraicClass) :
    D.totalSpacePullbackClass :=
  D.total_space_from_chern_weil_bridge hCW hFamily hCompact hPeriod hShimura

end E7ApproachFTotalSpaceData

/-- A model matching the paper warning: the total-space class exists, but the
fibre-level target class has not been algebraized. -/
def approachFTotalSpaceNoFibreCountermodel :
    E7ApproachFTotalSpaceData where
  e7ChernWeilBridge := True
  nonRigidE7Family := True
  compactifiedFamily := True
  algebraicPeriodMapToToroidalTarget := True
  shimuraSideAlgebraicClass := True
  totalSpacePullbackClass := True
  fibreLevelTargetClassAlgebraic := False
  total_space_from_chern_weil_bridge := fun _ _ _ _ _ => trivial

/-- The Approach F total-space construction does not self-close the
fibre-level algebraicity statement for the original variety. -/
theorem approach_f_total_space_does_not_self_close_fibre_level_class :
    Not
      (forall D : E7ApproachFTotalSpaceData,
        D.totalSpacePullbackClass ->
          D.fibreLevelTargetClassAlgebraic) := by
  intro h
  exact h approachFTotalSpaceNoFibreCountermodel trivial

/-- Dependency boundary for `thm:eigenvalue-separation`. -/
structure CMEigenvalueSeparationData where
  abelianTypeCMFibre : Prop
  nonAbelianE7CMFibre : Prop
  splitPrimeOutsideFiniteSet : Prop
  hondaTateForAbelianMotives : Prop
  hondaTateExtensionToNonAbelianCMMotives : Prop
  abelianTypeEigenvalueSeparation : Prop
  nonAbelianE7EigenvalueSeparation : Prop
  abelian_from_honda_tate :
    abelianTypeCMFibre ->
      splitPrimeOutsideFiniteSet ->
        hondaTateForAbelianMotives ->
          abelianTypeEigenvalueSeparation
  nonabelian_from_honda_tate_extension :
    nonAbelianE7CMFibre ->
      splitPrimeOutsideFiniteSet ->
        hondaTateExtensionToNonAbelianCMMotives ->
          nonAbelianE7EigenvalueSeparation

namespace CMEigenvalueSeparationData

/-- The abelian-type CM case is routed through the classical Honda-Tate input. -/
theorem abelian_type_eigenvalue_separation_from_honda_tate
    (D : CMEigenvalueSeparationData)
    (hAb : D.abelianTypeCMFibre)
    (hSplit : D.splitPrimeOutsideFiniteSet)
    (hHT : D.hondaTateForAbelianMotives) :
    D.abelianTypeEigenvalueSeparation :=
  D.abelian_from_honda_tate hAb hSplit hHT

/-- The non-abelian E7 CM case consumes the separate Honda-Tate extension. -/
theorem nonabelian_e7_eigenvalue_separation_from_honda_tate_extension
    (D : CMEigenvalueSeparationData)
    (hE7 : D.nonAbelianE7CMFibre)
    (hSplit : D.splitPrimeOutsideFiniteSet)
    (hExt : D.hondaTateExtensionToNonAbelianCMMotives) :
    D.nonAbelianE7EigenvalueSeparation :=
  D.nonabelian_from_honda_tate_extension hE7 hSplit hExt

end CMEigenvalueSeparationData

/-- A model where the abelian Honda-Tate theorem is available, but the
non-abelian E7 CM extension is absent. -/
def abelianHondaTateNoNonabelianEigenvalueCountermodel :
    CMEigenvalueSeparationData where
  abelianTypeCMFibre := True
  nonAbelianE7CMFibre := True
  splitPrimeOutsideFiniteSet := True
  hondaTateForAbelianMotives := True
  hondaTateExtensionToNonAbelianCMMotives := False
  abelianTypeEigenvalueSeparation := True
  nonAbelianE7EigenvalueSeparation := False
  abelian_from_honda_tate := fun _ _ _ => trivial
  nonabelian_from_honda_tate_extension := fun _ _ hExt => False.elim hExt

/-- Classical Honda-Tate for abelian motives does not self-close the
non-abelian E7 CM eigenvalue-separation clause. -/
theorem abelian_honda_tate_does_not_self_close_nonabelian_e7_eigenvalue_separation :
    Not
      (forall D : CMEigenvalueSeparationData,
        D.hondaTateForAbelianMotives ->
          D.nonAbelianE7CMFibre ->
            D.splitPrimeOutsideFiniteSet ->
              D.nonAbelianE7EigenvalueSeparation) := by
  intro h
  exact h abelianHondaTateNoNonabelianEigenvalueCountermodel
    trivial trivial trivial

end HodgeReduction
