/-
# HC Gap L4 — Action-level norm-conjugate identity on `PointEndHomQ` (R328).

R327 closed the algebraic norm-conjugate identity at the GaussianInt
level:

  `z * star z = (gaussianIntNormInt z : GaussianInt)`.

R328 (this file) lifts that identity ONE LEVEL UP, to the
`PointEndHomQ`-action layer:

  `action(z) * action(star z) = (Nm(z) : ℤ) • pointEnd_id_Q`

where `action z := GaussianInt_to_PointEndHomQ z` (R323) and the `*`
on the LHS is `PointEndHomQ_mul` (R322's composition-induced bilinear
multiplication). The integer norm `Nm(z) := gaussianIntNormInt z`
(R327) is non-negative, and strictly positive whenever `z ≠ 0`.

## What R328 (this file) provides (all kernel-pure)

* `pointEndHom_to_PointEndHomQ_mul_compat` — the inclusion
  `PointEndHom → PointEndHomQ` is multiplicative w.r.t. composition
  on the LHS and `PointEndHomQ_mul` on the RHS: concretely,
  `(1 ⊗ f) * (1 ⊗ g) = 1 ⊗ (f ∘ g)`. Built from R322's
  `PointEndHomQ_mul_tmul_tmul` compute-rule.
* `GaussianInt_to_PointEndHom_formula_intCast` — at an integer-cast
  input `(n : GaussianInt) = ⟨n, 0⟩`, the R317 formula reduces to
  `n • pointEnd_id`. Built from `Zsqrtd.intCast_re`/`intCast_im`.
* `gaussianInt_action_mul_star_eq_norm_smul` — the main R328 closure:
  `action(z) * action(star z) = (Nm(z) : ℤ) • pointEnd_id_Q`.
  Built by chaining the inclusion-mul-compat (Section 1), R318
  multiplicativity (`formula (z * w) = formula z ∘ formula w`),
  R327 norm-conjugate (`z * star z = (Nm z : GaussianInt)`),
  the int-cast reduction (Section 2), and ℤ-linearity of the
  inclusion to commute `pointEndHom_to_PointEndHomQ` past the `n •`.
* `gaussianInt_action_mul_star_eq_normQ_smul` — the same identity
  re-stated with the norm cast to ℚ: same equation under
  the ℚ-module structure on `PointEndHomQ`.
* `L4-G` markers, `R328` status flags, explicit non-closure markers.

## What R328 does NOT do

* Does NOT construct the inverse action `(1 / Nm(z)) • action(star z)`
  for nonzero `z` (that is the R329 target — the norm-conjugate
  identity here is the algebraic backbone but the inverse is a
  separate step requiring the ℚ-module reciprocal `1/Nm(z)`).
* Does NOT construct the `GaussianRationalFieldCandidate = ℚ(i)`
  algebra hom into `PointEndHomQ` (R330+).
* Does NOT construct true algebraic `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.

## Strategic anchor

R328's action-level norm-conjugate identity
`action(z) * action(star z) = Nm(z) • pointEnd_id_Q` on `PointEndHomQ`
is the KEY algebraic ingredient that unlocks invertibility of nonzero
GaussianInt actions on the rationalized carrier: combined with
`Nm(z) ≠ 0 ⇔ z ≠ 0` (R327's `gaussianIntNormInt_pos_of_ne_zero`)
and the ℚ-module structure on `PointEndHomQ` (R321), R329 will
immediately construct the inverse action `(1 / Nm(z)) • action(star z)`
since `1 / Nm(z) ∈ ℚ` acts on `PointEndHomQ` as a scalar from its
ℚ-module structure. That invertibility is what extends the GaussianInt
action to a `ℚ(i) = FractionRing GaussianInt → PointEndHomQ` action,
which is the source-side `End⁰(E)`-action structure consumed by
`canonicalE7ShimuraTor.mtCorrespondencePackage` (HC cone active
field 3). R328 is the algebraic kernel of that unlock: a single
equation on `PointEndHomQ`, derived by chaining R327 (GaussianInt
algebra), R318 (multiplicativity of the action formula), and R321/R322
(rationalization + multiplication).

All declarations kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` for substantive closure (markers/status only).
-/

import HodgeReduction.HCGapL4.GaussianIntNormConjugate
import HodgeReduction.HCGapL4.PointEndHomQMultiplication
import HodgeReduction.HCGapL4.GaussianFieldActionOnPointEndQ
import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomMultiplicative

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open scoped TensorProduct

/-! ## Section 1: inclusion is multiplicative w.r.t. composition

The R321 inclusion `pointEndHom_to_PointEndHomQ : PointEndHom →+ PointEndHomQ`
sends `f ↦ (1 : ℚ) ⊗ₜ f` (by definition, see
`pointEndHom_to_PointEndHomQ_apply`). The R322 multiplication
`PointEndHomQ_mul` on `PointEndHomQ` computes on simple tensors via
`PointEndHomQ_mul_tmul_tmul`:
`(p ⊗ₜ f) * (q ⊗ₜ g) = (p * q) ⊗ₜ (f ∘ g)`.
Specializing to `p = q = 1` gives the multiplicative-compat lemma
below. -/

/-- **R328 helper**: the canonical inclusion `PointEndHom → PointEndHomQ`
is multiplicative w.r.t. composition on `PointEndHom` and the R322
bilinear multiplication on `PointEndHomQ`:

  `(1 ⊗ f) * (1 ⊗ g) = 1 ⊗ (f ∘ g)`.

Equivalently:
  `PointEndHomQ_mul (pointEndHom_to_PointEndHomQ f) (pointEndHom_to_PointEndHomQ g)
    = pointEndHom_to_PointEndHomQ (pointEnd_comp f g)`.

Proof: unfold both inclusions to `1 ⊗ₜ -`, apply R322's
`PointEndHomQ_mul_tmul_tmul` compute-rule, simplify `1 * 1 = 1`. -/
theorem pointEndHom_to_PointEndHomQ_mul_compat (f g : PointEndHom) :
    PointEndHomQ_mul
        (pointEndHom_to_PointEndHomQ f)
        (pointEndHom_to_PointEndHomQ g)
      = pointEndHom_to_PointEndHomQ (pointEnd_comp f g) := by
  -- Unfold both inclusions: `pointEndHom_to_PointEndHomQ x = 1 ⊗ₜ x` (rfl)
  show PointEndHomQ_mul ((1 : ℚ) ⊗ₜ[ℤ] f) ((1 : ℚ) ⊗ₜ[ℤ] g)
      = ((1 : ℚ) ⊗ₜ[ℤ] (pointEnd_comp f g))
  rw [PointEndHomQ_mul_tmul_tmul]
  -- After mul rule: ((1 : ℚ) * 1) ⊗ₜ (f ∘ g) = 1 ⊗ₜ (f ∘ g)
  rw [mul_one]

/-! ## Section 2: formula at integer-cast input

The R317 formula on a Zsqrtd-integer-cast element collapses to a
plain integer multiple of the identity, since the imaginary part
vanishes. We use `Zsqrtd.intCast_re`/`intCast_im`. -/

/-- **R328 helper**: at an integer-cast input `(n : GaussianInt)`
(which is `⟨n, 0⟩ : Zsqrtd (-1)`), the R317 formula reduces to
`n • pointEnd_id`. Proof: unfold the formula, use
`Zsqrtd.intCast_re` and `Zsqrtd.intCast_im` to compute
`(n : GaussianInt).re = n` and `(n : GaussianInt).im = 0`, then
clean up with `simp`. -/
theorem GaussianInt_to_PointEndHom_formula_intCast (n : ℤ) :
    GaussianInt_to_PointEndHom_formula (n : GaussianInt)
      = n • pointEnd_id := by
  -- Unfold `GaussianInt_to_PointEndHom_formula`:
  -- = `pointEnd_add (pointEnd_zsmul z.re pointEnd_id) (pointEnd_zsmul z.im gaussianCM_phi)`
  -- and `pointEnd_add a b = a + b`, `pointEnd_zsmul k f = k • f`.
  show (((n : GaussianInt).re : ℤ) • pointEnd_id
         + ((n : GaussianInt).im : ℤ) • gaussianCM_phi : PointEndHom)
       = n • pointEnd_id
  rw [Zsqrtd.intCast_re, Zsqrtd.intCast_im]
  -- Goal: n • pointEnd_id + (0 : ℤ) • gaussianCM_phi = n • pointEnd_id
  simp

/-! ## Section 3: main theorem — action-level norm-conjugate identity

Chain:
  action(z) * action(star z)
    = (1 ⊗ formula z) * (1 ⊗ formula (star z))         [unfold inclusion]
    = 1 ⊗ (formula z ∘ formula (star z))              [Section 1, mul_compat]
    = 1 ⊗ formula (z * star z)                        [R318 multiplicativity, reverse]
    = 1 ⊗ formula ((Nm z : GaussianInt))              [R327 norm-conjugate]
    = 1 ⊗ (Nm z • pointEnd_id)                        [Section 2, formula_intCast]
    = Nm z • (1 ⊗ pointEnd_id)                        [linearity of inclusion]
    = Nm z • pointEnd_id_Q.                           [unfold pointEnd_id_Q]
-/

/-- **R328 main theorem**: the action-level norm-conjugate identity
on `PointEndHomQ`:

  `action(z) * action(star z) = (Nm(z) : ℤ) • pointEnd_id_Q`

where `action z := GaussianInt_to_PointEndHomQ z` (R323) and
`Nm(z) := gaussianIntNormInt z` (R327).

This is the action-level kernel that makes nonzero GaussianInt
actions invertible on the ℚ-module `PointEndHomQ`: combined with
`Nm(z) > 0` (R327 `gaussianIntNormInt_pos_of_ne_zero`) and the
ℚ-module structure on `PointEndHomQ`, it gives the inverse action
`(1 / Nm(z)) • action(star z)` (R329 target). -/
theorem gaussianInt_action_mul_star_eq_norm_smul (z : GaussianInt) :
    PointEndHomQ_mul
        (GaussianInt_to_PointEndHomQ z)
        (GaussianInt_to_PointEndHomQ (star z))
      = (gaussianIntNormInt z : ℤ) • pointEnd_id_Q := by
  -- Step 1: unfold `GaussianInt_to_PointEndHomQ z = 1 ⊗ formula z`.
  show PointEndHomQ_mul
         (pointEndHom_to_PointEndHomQ (GaussianInt_to_PointEndHom_formula z))
         (pointEndHom_to_PointEndHomQ
            (GaussianInt_to_PointEndHom_formula (star z)))
       = (gaussianIntNormInt z : ℤ) • pointEnd_id_Q
  -- Step 2: apply R328 helper `mul_compat`.
  rw [pointEndHom_to_PointEndHomQ_mul_compat]
  -- Goal: pointEndHom_to_PointEndHomQ
  --   (pointEnd_comp (formula z) (formula (star z)))
  --   = (Nm z : ℤ) • pointEnd_id_Q
  -- Step 3: reverse R318 multiplicativity:
  --   pointEnd_comp (formula z) (formula (star z)) = formula (z * star z).
  rw [← GaussianInt_to_PointEndHom_formula_mul]
  -- Goal: pointEndHom_to_PointEndHomQ (formula (z * star z))
  --   = (Nm z : ℤ) • pointEnd_id_Q
  -- Step 4: use R327 `gaussianInt_mul_star_eq_norm`:
  --   z * star z = (Nm z : GaussianInt).
  rw [gaussianInt_mul_star_eq_norm]
  -- Goal: pointEndHom_to_PointEndHomQ (formula ((Nm z : ℤ) : GaussianInt))
  --   = (Nm z : ℤ) • pointEnd_id_Q
  -- Step 5: use R328 helper `formula_intCast`:
  --   formula ((Nm z : ℤ) : GaussianInt) = (Nm z : ℤ) • pointEnd_id.
  rw [GaussianInt_to_PointEndHom_formula_intCast]
  -- Goal: pointEndHom_to_PointEndHomQ ((Nm z : ℤ) • pointEnd_id)
  --   = (Nm z : ℤ) • pointEnd_id_Q
  -- Step 6: ℤ-linearity of the inclusion (it's an `AddMonoidHom`,
  -- which respects `zsmul` via `map_zsmul`).
  rw [pointEndHom_to_PointEndHomQ.map_zsmul]
  -- Goal: (Nm z : ℤ) • pointEndHom_to_PointEndHomQ pointEnd_id
  --   = (Nm z : ℤ) • pointEnd_id_Q
  -- The RHS `pointEnd_id_Q` IS `pointEndHom_to_PointEndHomQ pointEnd_id`
  -- by definition (R322 Section 4).
  rfl

/-! ## Section 4: ℚ-cast version

The same identity stated with `gaussianIntNormQ z : ℚ` and the scalar
multiplication interpreted in `PointEndHomQ`'s ℚ-module structure.
This is the form directly consumed by R329 (where the reciprocal
`1/Nm(z)` lives in ℚ, not ℤ). -/

/-- **R328 ℚ-cast version**: the action-level norm-conjugate identity
with the norm cast to ℚ and the scalar multiplication interpreted in
the ℚ-module structure on `PointEndHomQ`.

This is the form fed to R329: the reciprocal `1/Nm(z) ∈ ℚ` requires
a ℚ-valued norm. Proof: combine the ℤ-version with the
ℤ-vs-ℚ scalar-action compatibility on ℚ-modules
(`Int.cast_smul_eq_zsmul` / `intCast_smul`). -/
theorem gaussianInt_action_mul_star_eq_normQ_smul (z : GaussianInt) :
    PointEndHomQ_mul
        (GaussianInt_to_PointEndHomQ z)
        (GaussianInt_to_PointEndHomQ (star z))
      = (gaussianIntNormQ z) • pointEnd_id_Q := by
  rw [gaussianInt_action_mul_star_eq_norm_smul]
  -- Goal: (Nm z : ℤ) • pointEnd_id_Q = (Nm z : ℚ) • pointEnd_id_Q
  -- where the LHS uses ℤ-scalar mult and the RHS uses ℚ-scalar mult.
  -- Use `Int.cast_smul_eq_zsmul` or its symm: for a ℚ-module `M` and
  -- `n : ℤ`, `((n : ℚ) : ℚ) • x = (n : ℤ) • x`.
  unfold gaussianIntNormQ
  -- Goal: (gaussianIntNormInt z : ℤ) • pointEnd_id_Q
  --   = ((gaussianIntNormInt z : ℤ) : ℚ) • pointEnd_id_Q
  exact (Int.cast_smul_eq_zsmul ℚ _ _).symm

/-! ## Section 5: `L4-G` disclosure markers -/

/-- **L4-G** bridge from R328's action-level norm-conjugate identity
to the R329 invertibility-of-nonzero-action construction (the inverse
is `(1/Nm(z)) • action(star z)`, immediately read off R328). -/
def L4_G_GaussianIntActionNormConjugate_To_Invertibility : Prop := True

/-- **L4-G** bridge from R328 to the GaussianRationalFieldCandidate
algebra-hom (`ℚ(i) → PointEndHomQ`). R328's identity is the algebraic
backbone that, combined with R329 invertibility + R330+ localization,
extends the GaussianInt action to a ℚ(i) action. -/
def L4_G_GaussianIntActionNormConjugate_To_GaussianFieldAction : Prop := True

/-- **L4-G** bridge from R328 to the active HC cone field
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R328 supplies the
algebraic action-level identity needed to extend the source-side
`End⁰(E)`-like action structure consumed by the MT correspondence. -/
def L4_G_GaussianIntActionNormConjugate_To_mtCorrespondencePackage : Prop := True

/-! ## Section 6: status flags -/

/-- **R328 status**: inclusion mul-compat
`pointEndHom_to_PointEndHomQ_mul_compat` closed. -/
def R328_Status_PointEndHom_Mul_Compat_Closed : Prop := True

/-- **R328 status**: formula on integer-cast input
`GaussianInt_to_PointEndHom_formula_intCast` closed. -/
def R328_Status_Formula_IntCast_Closed : Prop := True

/-- **R328 status**: main theorem (ℤ-version)
`gaussianInt_action_mul_star_eq_norm_smul` closed. -/
def R328_Status_Action_Mul_Star_Eq_NormSmul_Closed : Prop := True

/-- **R328 status**: ℚ-cast version
`gaussianInt_action_mul_star_eq_normQ_smul` closed. -/
def R328_Status_Action_Mul_Star_Eq_NormQSmul_Closed : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R328 non-closure (1/3)**: does NOT construct the inverse action
`(1 / Nm(z)) • action(star z)` for nonzero `z` (R329 target). -/
theorem R328_does_not_construct_inverse_action : True := trivial

/-- **R328 non-closure (2/3)**: does NOT construct the
`GaussianRationalFieldCandidate = ℚ(i) → PointEndHomQ` algebra hom
(R330+ target). -/
theorem R328_does_not_construct_GaussianField_action : True := trivial

/-- **R328 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R328_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
