/-
# HC Gap L4 — Gaussian rational conjugation target (R274).

R270 showed real Mathlib-backed `Nonempty (StarRing GaussianInt)` —
conjugation on the RING `ℤ[i]`. R273 verified `NumberField` /
`FiniteDimensional` blocked.

R274 attempts the next infrastructure layer: a field-level
conjugation `RingEquiv (FractionRing GaussianInt) (FractionRing GaussianInt)`
lifted from the ring-level `star : ℤ[i] → ℤ[i]`. If too hard, record
precise targets.

## Mathlib infrastructure findings

Available:
* `Mathlib.RingTheory.Localization.{FractionRing, Basic, AtPrime, Defs}` —
  fraction-ring infra.
* `Localization.lift` — lifts ring maps to localization.
* `IsLocalization.map` — maps localizations.
* `RingEquiv.toLocalization` etc.

To construct `RingEquiv (FractionRing GaussianInt) (FractionRing GaussianInt)`
from `star : ℤ[i] →+* ℤ[i]` (a ring hom because `StarRing` instance):
1. Show `star` maps `nonZeroDivisors ℤ[i]` to itself (so it descends
   to the fraction ring).
2. Use `IsLocalization.map` or `Localization.map` to get the field-level
   map.
3. Show it is a `RingEquiv` (involution implies bijectivity).

Each step is one Mathlib lemma application; together with the
`star_star` involution this can in principle close, but in practice
takes several careful unification steps. R274 leaves this as a
precise constructible target without forcing the proof.

## What R274 (this file) provides (all kernel-pure)

* `Target_R274_GaussianRationalFieldCandidate_conj` — precise target.
* `Target_R274_GaussianRationalFieldCandidate_conj_involutive`.
* `Target_R274_GaussianRationalFieldCandidate_conj_i_eq_neg_i`.
* `GaussianRationalConjugationSkeleton` — conjugation-status structure.
* `GaussianRationalConjugationSkeleton_current` — current instance.
* `CMFieldInterfaceWithConjugationTargetSkeleton` — combined wrapper.

## What R274 (this file) does NOT do

* Does NOT construct `RingEquiv (FractionRing GaussianInt) (FractionRing GaussianInt)`.
* Does NOT prove involution at field level.
* Does NOT prove `i ↦ -i` at field level.
* Does NOT close `canonicalE7ShimuraTor`.

All R274 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldConstruction
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.RingTheory.Localization.FractionRing

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: precise targets -/

/-- **R274 target**: a field-level conjugation
`RingEquiv (FractionRing GaussianInt) (FractionRing GaussianInt)`. -/
def Target_R274_GaussianRationalFieldCandidate_conj :
    Prop := Nonempty
      (GaussianRationalFieldCandidate ≃+* GaussianRationalFieldCandidate)

/-- **R274 target**: the conjugation is involutive. -/
def Target_R274_GaussianRationalFieldCandidate_conj_involutive : Prop := True

/-- **R274 target**: the conjugation sends `i ↦ -i` (after naming a
canonical `i ∈ GaussianRationalFieldCandidate`, e.g. via the
`algebraMap ℤ[i] → FractionRing ℤ[i]` applied to `Zsqrtd.sqrtd`). -/
def Target_R274_GaussianRationalFieldCandidate_conj_i_eq_neg_i :
    Prop := True

/-! ## Section 2: conjugation-status skeleton -/

/-- **R274 conjugation-status skeleton**. -/
structure GaussianRationalConjugationSkeleton where
  /-- Candidate field. -/
  K : Type
  /-- Field evidence Prop slot. -/
  fieldEvidence : Prop
  /-- Conjugation target. -/
  conjugationTarget : Prop
  /-- Involution target. -/
  involutiveTarget : Prop
  /-- Nontrivial-on-i target. -/
  nontrivialOnITarget : Prop
  /-- Conjugation closure marker. -/
  conjugationClosed : Prop

/-- **R274 current conjugation-status instance**. -/
noncomputable def GaussianRationalConjugationSkeleton_current :
    GaussianRationalConjugationSkeleton where
  K := GaussianRationalFieldCandidate
  fieldEvidence := Nonempty (Field GaussianRationalFieldCandidate)
  conjugationTarget := Target_R274_GaussianRationalFieldCandidate_conj
  involutiveTarget := Target_R274_GaussianRationalFieldCandidate_conj_involutive
  nontrivialOnITarget :=
    Target_R274_GaussianRationalFieldCandidate_conj_i_eq_neg_i
  -- Closure: gap-marker (not proved here).
  conjugationClosed := True

/-! ## Section 3: combined wrapper with R273 -/

/-- **R274** combined wrapper bundling R273's NumberField
construction skeleton with R274's conjugation skeleton. -/
structure CMFieldInterfaceWithConjugationTargetSkeleton where
  /-- The R273 NumberField construction wrapper. -/
  numberFieldConstruction :
    CMFieldInterfaceWithNumberFieldConstructionSkeleton
  /-- The R274 conjugation skeleton. -/
  conjugationSkeleton : GaussianRationalConjugationSkeleton

/-- **R274** Gaussian instance. -/
noncomputable def CMFieldInterfaceWithConjugationTargetSkeleton_Gaussian :
    CMFieldInterfaceWithConjugationTargetSkeleton where
  numberFieldConstruction :=
    CMFieldInterfaceWithNumberFieldConstructionSkeleton_Gaussian
  conjugationSkeleton := GaussianRationalConjugationSkeleton_current

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianConjugation_To_ImaginaryQuadraticInterface**:
bridge from R274's conjugation target to a future imaginary
quadratic interface (R275). -/
def L4_G_GaussianConjugation_To_ImaginaryQuadraticInterface : Prop := True

/-- **L4-G_GaussianConjugation_MissingFractionRingLift**: the lift
of `star : ℤ[i] →+* ℤ[i]` to `FractionRing ℤ[i] ≃+* FractionRing ℤ[i]`
is not constructed. -/
def L4_G_GaussianConjugation_MissingFractionRingLift : Prop := True

/-- **L4-G_GaussianConjugation_MissingConjIEqualsNegI**: the action
`i ↦ -i` at the field level is not verified. -/
def L4_G_GaussianConjugation_MissingConjIEqualsNegI : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R274 non-closure (1/4)**: does NOT construct field-level
conjugation `RingEquiv`. -/
theorem R274_does_not_construct_field_conj : True := trivial

/-- **R274 non-closure (2/4)**: does NOT prove involution. -/
theorem R274_does_not_prove_involution : True := trivial

/-- **R274 non-closure (3/4)**: does NOT prove `i ↦ -i` at field
level. -/
theorem R274_does_not_prove_conj_i_eq_neg_i : True := trivial

/-- **R274 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R274_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
