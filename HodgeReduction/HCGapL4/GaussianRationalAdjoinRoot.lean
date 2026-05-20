/-
# HC Gap L4 — AdjoinRoot (X²+1) feasibility for ℚ(i) (R280).

R273 left `FiniteDimensional ℚ GaussianRationalFieldCandidate`,
`NumberField`, `finrank = 2` as open targets. R280 starts path A:
build the AdjoinRoot side and prove finite-dim + finrank=2 there.

If R281 manages to construct an `AlgEquiv`
`GaussianRationalFieldCandidate ≃ₐ[ℚ] AdjoinRoot (X²+1)`, the R273
targets transfer automatically.

## Mathlib infrastructure used

* `Mathlib.RingTheory.AdjoinRoot.lean:61` — `AdjoinRoot [CommRing R] (f : R[X])`.
* `Mathlib.RingTheory.AdjoinRoot.lean:521` — `AdjoinRoot.powerBasis (hf : f ≠ 0)`
  gives a `PowerBasis K (AdjoinRoot f)` for any `[Field K]`.
* `Mathlib.RingTheory.PowerBasis.lean:74` — `PowerBasis.finite` gives
  `Module.Finite K S` (= `FiniteDimensional K S` for fields).
* `Mathlib.RingTheory.PowerBasis.lean:77` — `PowerBasis.finrank` gives
  `Module.finrank K S = pb.dim`.
* `Mathlib.Algebra.Polynomial.Degree.Operations.lean:608` —
  `X_pow_add_C_ne_zero`.
* `Mathlib.Algebra.Polynomial.Degree.Operations.lean:621` —
  `natDegree_X_pow_add_C`.

## What R280 (this file) provides (all kernel-pure)

* `GaussianPolynomialOverQ := X^2 + 1 : ℚ[X]`.
* `GaussianPolynomialOverQ_ne_zero` — Mathlib-backed nonzero proof.
* `GaussianPolynomialOverQ_natDegree_eq_two`.
* `GaussianAdjoinRootCandidate := AdjoinRoot GaussianPolynomialOverQ`.
* `GaussianAdjoinRoot_root_sq_add_one` — `(root)^2 + 1 = 0` via
  `AdjoinRoot.aeval_root`.
* `GaussianAdjoinRootCandidate_finiteDimensional` — via PowerBasis.
* `GaussianAdjoinRootCandidate_finrank_eq_two` — via PowerBasis.
* `Target_GaussianRationalFieldCandidate_algEquiv_AdjoinRoot` — R281
  target.
* `GaussianAdjoinRootConstructionSkeleton` + current instance.

## What R280 (this file) does NOT do

* Does NOT construct `AlgEquiv GaussianRationalFieldCandidate ≃ₐ[ℚ]
  AdjoinRoot (X²+1)` (R281 target).
* Does NOT prove `NumberField GaussianRationalFieldCandidate` directly.
* Does NOT construct `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

All R280 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalNumberFieldConstruction
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.RingTheory.PowerBasis
import Mathlib.Algebra.Polynomial.Degree.Operations
import Mathlib.Algebra.Polynomial.Monic

namespace HodgeReduction
namespace HCGapL4

open Polynomial
open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: the polynomial `X² + 1 : ℚ[X]` -/

/-- **R280** the polynomial whose root is `i`. -/
noncomputable def GaussianPolynomialOverQ : ℚ[X] := X^2 + 1

/-- **R280** `X² + 1 ≠ 0` via `X_pow_add_C_ne_zero`. -/
theorem GaussianPolynomialOverQ_ne_zero : GaussianPolynomialOverQ ≠ 0 := by
  unfold GaussianPolynomialOverQ
  show (X^2 + 1 : ℚ[X]) ≠ 0
  rw [show (1 : ℚ[X]) = C 1 from (map_one C).symm]
  exact X_pow_add_C_ne_zero (by norm_num) 1

/-- **R280** `(X² + 1).natDegree = 2`. -/
theorem GaussianPolynomialOverQ_natDegree_eq_two :
    GaussianPolynomialOverQ.natDegree = 2 := by
  unfold GaussianPolynomialOverQ
  show (X^2 + 1 : ℚ[X]).natDegree = 2
  rw [show (1 : ℚ[X]) = C 1 from (map_one C).symm]
  exact natDegree_X_pow_add_C

/-! ## Section 2: AdjoinRoot candidate -/

/-- **R280** the AdjoinRoot candidate for `ℚ(i)`. -/
noncomputable abbrev GaussianAdjoinRootCandidate :=
  AdjoinRoot GaussianPolynomialOverQ

/-! ## Section 3: root relation `(root)² + 1 = 0`

`AdjoinRoot.eval₂_root` / `AdjoinRoot.aeval_eq` evaluate the polynomial
at its root, giving 0 in the quotient. -/

/-- **R280** root relation: `(root)² + 1 = 0` in `AdjoinRoot (X²+1)`. -/
theorem GaussianAdjoinRoot_root_sq_add_one :
    (AdjoinRoot.root GaussianPolynomialOverQ)^2 + 1 = 0 := by
  have h := AdjoinRoot.eval₂_root GaussianPolynomialOverQ
  -- h : eval₂ (of f) (root f) f = 0
  -- For f = X^2 + 1, eval₂ of root f = (root f)^2 + 1
  unfold GaussianPolynomialOverQ at h
  simp [eval₂_add, eval₂_pow, eval₂_X, eval₂_one] at h
  exact h

/-! ## Section 4: PowerBasis for AdjoinRoot ℚ(X²+1) -/

/-- **R280** the PowerBasis `{1, root}` for `GaussianAdjoinRootCandidate`. -/
noncomputable def GaussianAdjoinRoot_powerBasis :
    PowerBasis ℚ GaussianAdjoinRootCandidate :=
  AdjoinRoot.powerBasis GaussianPolynomialOverQ_ne_zero

/-- **R280** `dim` of the PowerBasis is `natDegree` (= 2). -/
theorem GaussianAdjoinRoot_powerBasis_dim :
    GaussianAdjoinRoot_powerBasis.dim = 2 := by
  show (AdjoinRoot.powerBasis GaussianPolynomialOverQ_ne_zero).dim = 2
  rw [AdjoinRoot.powerBasis_dim]
  exact GaussianPolynomialOverQ_natDegree_eq_two

/-! ## Section 5: finite-dimensionality + finrank = 2 -/

/-- **R280** `FiniteDimensional ℚ GaussianAdjoinRootCandidate` via the
PowerBasis. -/
theorem GaussianAdjoinRootCandidate_finiteDimensional :
    FiniteDimensional ℚ GaussianAdjoinRootCandidate :=
  GaussianAdjoinRoot_powerBasis.finite

/-- **R280** `finrank ℚ GaussianAdjoinRootCandidate = 2`. -/
theorem GaussianAdjoinRootCandidate_finrank_eq_two :
    Module.finrank ℚ GaussianAdjoinRootCandidate = 2 := by
  rw [GaussianAdjoinRoot_powerBasis.finrank, GaussianAdjoinRoot_powerBasis_dim]

/-! ## Section 6: R281 target placeholder -/

/-- **R280 / R281 target**: `AlgEquiv` from
`GaussianRationalFieldCandidate` to `GaussianAdjoinRootCandidate`. If
R281 succeeds in constructing this, finite-dimensionality and
`NumberField` transfer to `GaussianRationalFieldCandidate`. -/
def Target_GaussianRationalFieldCandidate_algEquiv_AdjoinRoot : Prop :=
  Nonempty
    (GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate)

/-! ## Section 7: status skeleton -/

/-- **R280 status skeleton**. Records the polynomial + candidate +
proven status of root/finrank/AlgEquiv. -/
structure GaussianAdjoinRootConstructionSkeleton where
  /-- The polynomial. -/
  polynomial : ℚ[X]
  /-- The AdjoinRoot candidate type. -/
  adjoinRootCandidate : Type
  /-- Root relation target / closed Prop. -/
  rootRelationTarget : Prop
  /-- Finite-dimensional target / closed Prop. -/
  finiteDimensionalTarget : Prop
  /-- finrank = 2 target / closed Prop. -/
  finrankTwoTarget : Prop
  /-- AlgEquiv target. -/
  algEquivTarget : Prop

/-- **R280** current status: root relation + finrank closed; AlgEquiv
remains target for R281. -/
noncomputable def GaussianAdjoinRootConstructionSkeleton_current :
    GaussianAdjoinRootConstructionSkeleton where
  polynomial := GaussianPolynomialOverQ
  adjoinRootCandidate := GaussianAdjoinRootCandidate
  rootRelationTarget :=
    (AdjoinRoot.root GaussianPolynomialOverQ)^2 + 1 = 0
  finiteDimensionalTarget :=
    FiniteDimensional ℚ GaussianAdjoinRootCandidate
  finrankTwoTarget :=
    Module.finrank ℚ GaussianAdjoinRootCandidate = 2
  algEquivTarget := Target_GaussianRationalFieldCandidate_algEquiv_AdjoinRoot

/-! ## Section 8: closure evidence theorems -/

/-- **R280 closure**: root relation is closed. -/
theorem R280_rootRelation_closed :
    (AdjoinRoot.root GaussianPolynomialOverQ)^2 + 1 = 0 :=
  GaussianAdjoinRoot_root_sq_add_one

/-- **R280 closure**: finite-dimensional is closed for AdjoinRoot. -/
theorem R280_finiteDimensional_closed :
    FiniteDimensional ℚ GaussianAdjoinRootCandidate :=
  GaussianAdjoinRootCandidate_finiteDimensional

/-- **R280 closure**: finrank = 2 is closed for AdjoinRoot. -/
theorem R280_finrankTwo_closed :
    Module.finrank ℚ GaussianAdjoinRootCandidate = 2 :=
  GaussianAdjoinRootCandidate_finrank_eq_two

/-! ## Section 9: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianAdjoinRoot_To_NumberField**: bridge from R280's
AdjoinRoot closure to a `NumberField GaussianRationalFieldCandidate`
proof — requires R281's AlgEquiv. -/
def L4_G_GaussianAdjoinRoot_To_NumberField : Prop := True

/-- **L4-G_GaussianAdjoinRoot_To_FiniteDimensional**: bridge from
finrank=2 on AdjoinRoot to finrank=2 on GaussianRationalFieldCandidate
— requires R281's AlgEquiv. -/
def L4_G_GaussianAdjoinRoot_To_FiniteDimensional : Prop := True

/-- **L4-G_GaussianAdjoinRoot_To_AlgEquivFractionRingGaussianInt**:
bridge to R281's AlgEquiv target. -/
def L4_G_GaussianAdjoinRoot_To_AlgEquivFractionRingGaussianInt :
    Prop := True

/-- **L4-G_GaussianAdjoinRoot_MissingPowerBasisFinrank**: not missing
— R280 closed it (kept for symmetry; documentation marker). -/
def L4_G_GaussianAdjoinRoot_MissingPowerBasisFinrank : Prop := True

/-! ## Section 10: explicit non-closure -/

/-- **R280 non-closure (1/5)**: does NOT prove `NumberField
GaussianRationalFieldCandidate` directly (only on AdjoinRoot side
via R281 AlgEquiv). -/
theorem R280_does_not_prove_NumberField_on_FractionRing : True := trivial

/-- **R280 non-closure (2/5)**: does NOT prove `FiniteDimensional ℚ
GaussianRationalFieldCandidate` (only on AdjoinRoot side). -/
theorem R280_does_not_prove_finiteDimensional_on_FractionRing :
    True := trivial

/-- **R280 non-closure (3/5)**: does NOT construct AlgEquiv (R281). -/
theorem R280_does_not_construct_algEquiv : True := trivial

/-- **R280 non-closure (4/5)**: does NOT construct `End⁰(E)`. -/
theorem R280_does_not_construct_End0 : True := trivial

/-- **R280 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R280_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
