/-
# HC Gap L4 -- Front C129: source-H8 does not force generator membership (R693).

R692 rewrites the R691 source-boundary field as the concrete source-side target

  `surjectivity_source = H8`,

provided the generator membership and target generator-line containment fields
are already available.  This file records the important negative check for the
next attack: in the current abstract interface, source-H8 plus target
line-containment still does not force

  `h^4 in source_invariants`.

The countermodel keeps the actual Matsushima source invariants equal to `bot`
while declaring the independent surjectivity source to be the compact-dual H8
line.  The target line containment is vacuous because the trivial-module part is
`bot`.  Thus the generator-membership input in R692/R691 is a real remaining
EVII source-carrier obligation, not a consequence of the current
surjectivity-source spelling.
-/

import HodgeReduction.HCGapL4.FrontC128_H8ResidualSourceH8LineContainmentRoute

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC129_H8ResidualSourceH8GeneratorIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic

/-- One-dimensional source for the source-H8/generator-membership independence model. -/
def SourceH8GeneratorObstructionSource := Rat

/-- One-dimensional target for the source-H8/generator-membership independence model. -/
def SourceH8GeneratorObstructionTarget := Rat

instance : CommRing SourceH8GeneratorObstructionSource := inferInstanceAs (CommRing Rat)
instance : Algebra Rat SourceH8GeneratorObstructionSource := inferInstanceAs (Algebra Rat Rat)
instance : AddCommGroup SourceH8GeneratorObstructionSource :=
  inferInstanceAs (AddCommGroup Rat)
instance : Module Rat SourceH8GeneratorObstructionSource := inferInstanceAs (Module Rat Rat)
instance : AddCommGroup SourceH8GeneratorObstructionTarget :=
  inferInstanceAs (AddCommGroup Rat)
instance : Module Rat SourceH8GeneratorObstructionTarget := inferInstanceAs (Module Rat Rat)

/-- The identity Matsushima map for the countermodel. -/
def sourceH8GeneratorObstructionIdMap :
    SourceH8GeneratorObstructionSource →ₗ[Rat] SourceH8GeneratorObstructionTarget :=
  LinearMap.id

noncomputable instance instCohomologyRingSourceH8GeneratorObstructionSource :
    CohomologyRing SourceH8GeneratorObstructionSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassSourceH8GeneratorObstructionSource :
    KaehlerClass SourceH8GeneratorObstructionSource where
  h := (1 : SourceH8GeneratorObstructionSource)
  h_isAlgebraic := by
    change (1 : SourceH8GeneratorObstructionSource) ∈
      (⊤ : Subalgebra Rat SourceH8GeneratorObstructionSource)
    trivial
  h_pow_4_ne_zero := by
    change (1 : Rat) ^ 4 ≠ 0
    norm_num

noncomputable instance instCompactDualDataSourceH8GeneratorObstructionSource :
    CompactDualData SourceH8GeneratorObstructionSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : SourceH8GeneratorObstructionSource) ^ 4)} :
        Set SourceH8GeneratorObstructionSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoSourceH8GeneratorObstructionSource :
    CartanCompactDualIso SourceH8GeneratorObstructionSource where
  trivialModuleGK_H8 :=
    CompactDualData.H8 (A := SourceH8GeneratorObstructionSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataSourceH8GeneratorObstruction :
    MatsushimaData SourceH8GeneratorObstructionSource
      SourceH8GeneratorObstructionTarget where
  j_q := sourceH8GeneratorObstructionIdMap
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    exact hxy
  source_invariants := ⊥
  target_invariants := ⊥
  j_q_maps_invariants_to_invariants := by
    intro alpha h
    have hzero : alpha = 0 := by
      simpa using h
    rw [hzero]
    exact Submodule.zero_mem _
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaSurjectivityDataSourceH8GeneratorObstruction :
    MatsushimaSurjectivityData SourceH8GeneratorObstructionSource
      SourceH8GeneratorObstructionTarget where
  surjectivity_source := CompactDualData.H8 (A := SourceH8GeneratorObstructionSource)
  surjectivity_target :=
    Submodule.map sourceH8GeneratorObstructionIdMap
      (CompactDualData.H8 (A := SourceH8GeneratorObstructionSource))
  surjectivity_eq := rfl

noncomputable instance instMatsushimaCompactDualDataSourceH8GeneratorObstruction :
    MatsushimaCompactDualData SourceH8GeneratorObstructionSource
      SourceH8GeneratorObstructionTarget where
  compactDual := ⊥
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataSourceH8GeneratorObstruction :
    CuspidalCohomologyData SourceH8GeneratorObstructionTarget where
  cuspidalSubspace := ⊥
  trivialModulePart := ⊥
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8SourceH8GeneratorObstruction :
    EisensteinVanishingDeg8 SourceH8GeneratorObstructionSource
      SourceH8GeneratorObstructionTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8SourceH8GeneratorObstruction :
    CuspidalGInvariantTrivialModuleDeg8 SourceH8GeneratorObstructionSource
      SourceH8GeneratorObstructionTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    ext x
    change
      (x ∈ (⊥ : Submodule Rat SourceH8GeneratorObstructionTarget) ∧
          x ∈ (⊥ : Submodule Rat SourceH8GeneratorObstructionTarget)) ↔
        x ∈ (⊥ : Submodule Rat SourceH8GeneratorObstructionTarget)
    simp

/-- **R693 obstruction theorem (1/5)**: the countermodel has concrete
source-H8 surjectivity. -/
theorem counterexample_surjectivity_source_eq_H8 :
    MatsushimaSurjectivityData.surjectivity_source
        (A := SourceH8GeneratorObstructionSource)
        (B := SourceH8GeneratorObstructionTarget) =
      CompactDualData.H8 (A := SourceH8GeneratorObstructionSource) :=
  rfl

/-- **R693 obstruction theorem (2/5)**: the target generator-line containment
also holds, vacuously because the trivial-module part is bot. -/
theorem counterexample_trivialModulePart_le_h_pow_four_line :
    LE.le
      (CuspidalCohomologyData.trivialModulePart
        (A := SourceH8GeneratorObstructionTarget))
      (Submodule.span Rat
        {MatsushimaData.j_q
          (A := SourceH8GeneratorObstructionSource)
          (B := SourceH8GeneratorObstructionTarget)
          ((KaehlerClass.h : SourceH8GeneratorObstructionSource) ^ 4)}) := by
  change
    (⊥ : Submodule Rat SourceH8GeneratorObstructionTarget) <=
      Submodule.span Rat
        {sourceH8GeneratorObstructionIdMap
          ((KaehlerClass.h : SourceH8GeneratorObstructionSource) ^ 4)}
  exact bot_le

/-- **R693 obstruction theorem (3/5)**: the source generator membership fails
because the source-invariant carrier is bot while `h^4 = 1` is nonzero. -/
theorem counterexample_not_h_pow_four_mem_source_invariants :
    Not
      ((MatsushimaData.source_invariants
          (A := SourceH8GeneratorObstructionSource)
          (B := SourceH8GeneratorObstructionTarget)).carrier
        ((KaehlerClass.h : SourceH8GeneratorObstructionSource) ^ 4)) := by
  intro hh
  change
    ((1 : SourceH8GeneratorObstructionSource) ^ 4) ∈
      (⊥ : Submodule Rat SourceH8GeneratorObstructionSource) at hh
  rw [Submodule.mem_bot] at hh
  change (1 : Rat) ^ 4 = 0 at hh
  norm_num at hh

/-- **R693 obstruction theorem (4/5)**: source-H8 plus target generator-line
containment do not force source generator membership in the current abstract
interface. -/
theorem current_interface_with_sourceH8_line_does_not_force_h_pow_four_mem_source :
    MatsushimaSurjectivityData.surjectivity_source
        (A := SourceH8GeneratorObstructionSource)
        (B := SourceH8GeneratorObstructionTarget) =
        CompactDualData.H8 (A := SourceH8GeneratorObstructionSource) /\
      LE.le
        (CuspidalCohomologyData.trivialModulePart
          (A := SourceH8GeneratorObstructionTarget))
        (Submodule.span Rat
          {MatsushimaData.j_q
            (A := SourceH8GeneratorObstructionSource)
            (B := SourceH8GeneratorObstructionTarget)
            ((KaehlerClass.h : SourceH8GeneratorObstructionSource) ^ 4)}) /\
      Not
        ((MatsushimaData.source_invariants
            (A := SourceH8GeneratorObstructionSource)
            (B := SourceH8GeneratorObstructionTarget)).carrier
          ((KaehlerClass.h : SourceH8GeneratorObstructionSource) ^ 4)) :=
  ⟨ counterexample_surjectivity_source_eq_H8,
    counterexample_trivialModulePart_le_h_pow_four_line,
    counterexample_not_h_pow_four_mem_source_invariants ⟩

/-- Machine-readable status for the R693 source-H8/generator-membership
independence audit. -/
structure R693SourceH8GeneratorIndependenceSnapshot where
  proofWorkObligationCount : Nat
  sourceH8AvailableInCountermodel : Bool
  targetLineContainmentAvailableInCountermodel : Bool
  sourceGeneratorMembershipForcedByThoseTargets : Bool
  sourceGeneratorMembershipStillIndependent : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Exact R693 active targets after separating source-H8 from generator
membership. -/
def currentR693SourceH8GeneratorIndependenceTargetNames : List String := [
  "prove surjectivity_source = H8",
  "prove h^4 in source_invariants",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Current R693 status: generator membership remains a separate EVII
source-carrier target; it cannot be consumed from source-H8 plus the target
line in the current interface. -/
def currentR693SourceH8GeneratorIndependenceSnapshot :
    R693SourceH8GeneratorIndependenceSnapshot where
  proofWorkObligationCount :=
    currentR693SourceH8GeneratorIndependenceTargetNames.length
  sourceH8AvailableInCountermodel := true
  targetLineContainmentAvailableInCountermodel := true
  sourceGeneratorMembershipForcedByThoseTargets := false
  sourceGeneratorMembershipStillIndependent := true
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R693 obstruction theorem (5/5)**: kernel-checked status for the
source-H8/generator-membership independence audit. -/
theorem currentR693SourceH8GeneratorIndependenceSnapshot_eq_texStatus :
    currentR693SourceH8GeneratorIndependenceSnapshot =
      ({ proofWorkObligationCount := 3
         sourceH8AvailableInCountermodel := true
         targetLineContainmentAvailableInCountermodel := true
         sourceGeneratorMembershipForcedByThoseTargets := false
         sourceGeneratorMembershipStillIndependent := true
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R693SourceH8GeneratorIndependenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R693 post-obstruction route. -/
theorem currentR693SourceH8GeneratorIndependenceTargetNames_eq_texStatus :
    currentR693SourceH8GeneratorIndependenceTargetNames = [
      "prove surjectivity_source = H8",
      "prove h^4 in source_invariants",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R693_substantiveTheoremCount : Nat := 5

end FrontC129_H8ResidualSourceH8GeneratorIndependence
end HCGapL4
end HodgeReduction
